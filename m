Return-Path: <linux-kernel-owner+w=401wt.eu-S965545AbXHaQ6e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965545AbXHaQ6e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 12:58:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760105AbXHaQ6Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 12:58:25 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43035 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759569AbXHaQ6Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 12:58:25 -0400
Message-ID: <46D848AB.2070604@redhat.com>
Date: Fri, 31 Aug 2007 12:58:19 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Esteban Fernandez <estfern@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Pausing kernel boot messages
References: <179e6e720708270421r5f07f9dfp434077f6a106d2d7@mail.gmail.com>
In-Reply-To: <179e6e720708270421r5f07f9dfp434077f6a106d2d7@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/2007 07:21 AM, Esteban Fernandez wrote:
> How do you pause the kernel boot messages ?
> 
> ^S, Pause and Scroll lock do nothing and you can't Shift-Page-Up  after a
> kernel panic.
> 

You could try linux-2.6-debug-boot-delay.patch from Randy Dunlap,
included in the Fedora 7 kernel.
