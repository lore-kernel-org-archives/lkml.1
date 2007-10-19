Return-Path: <linux-kernel-owner+w=401wt.eu-S967252AbXJSVxy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967252AbXJSVxy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 17:53:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935827AbXJSVxp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 17:53:45 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36822 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935486AbXJSVxo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 17:53:44 -0400
Message-ID: <47192763.9050004@redhat.com>
Date: Fri, 19 Oct 2007 17:53:39 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [2.6.23] tasks stuck in running state?
References: <47192425.6020507@garzik.org>
In-Reply-To: <47192425.6020507@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19/2007 05:39 PM, Jeff Garzik wrote:
> On my main devel box, vanilla 2.6.23 on x86-64/Fedora-7, I'm seeing a
> certain behavior at least once a day.  I'll start a kernel build (make
> -sj5 on this box), and it will "hang" in the following way:
> 

Can you try to strace the hanging task?

