Return-Path: <linux-kernel-owner+w=401wt.eu-S1754403AbXFYQzf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754403AbXFYQzf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 12:55:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750841AbXFYQz1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 12:55:27 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35521 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750812AbXFYQz1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 12:55:27 -0400
Message-ID: <467FF37D.5000304@redhat.com>
Date: Mon, 25 Jun 2007 12:55:25 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: dave young <hidave.darkstar@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: i386 boot fail, EIP in __change_page_attr:166
References: <a8e1da0706242043w56ed75f0h208ee9646ae7b7d0@mail.gmail.com>
In-Reply-To: <a8e1da0706242043w56ed75f0h208ee9646ae7b7d0@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/2007 11:43 PM, dave young wrote:
> Hi,
> I reconfig my kernel, boot and oops, EIP in __change_page_attr:166, I
> tried 2.6.22-rc4-mm2 and 2.6.22-rc5 , same result.
> 
> Anyone has some clues?
> 
> here is my config file:

Where are the oops messages?

