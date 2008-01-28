Return-Path: <linux-kernel-owner+w=401wt.eu-S1762650AbYA1XeH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762650AbYA1XeH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 18:34:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751632AbYA1Xdx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 18:33:53 -0500
Received: from xenotime.net ([66.160.160.81]:50858 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1764382AbYA1Xdw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 18:33:52 -0500
Date: Mon, 28 Jan 2008 15:33:50 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: dsterba@suse.cz, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, jkosina@suse.cz, benm@symmetric.co.nz,
       stephen@symmetric.co.nz
Subject: Re: [PATCH] ipwireless: driver for 3G PC Card
Message-Id: <20080128153350.c3fd0406.rdunlap@xenotime.net>
In-Reply-To: <479E654F.4070804@gmail.com>
References: <20080128171929.GA3906@ds.suse.cz>
	<20080128100854.fe7acad8.rdunlap@xenotime.net>
	<479E62AB.3010603@gmail.com>
	<20080128152809.59d1f52a.rdunlap@xenotime.net>
	<479E654F.4070804@gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jan 2008 00:29:19 +0100 Jiri Slaby wrote:

> On 01/29/2008 12:28 AM, Randy Dunlap wrote:
> > On Tue, 29 Jan 2008 00:18:03 +0100 Jiri Slaby wrote:
> > 
> >> On 01/28/2008 07:08 PM, Randy Dunlap wrote:
> >>>> +/*
> >>>> + * @return 1 if something has been received from hw
> >>> What's with the '@'?
> >> ...
> >>>> +
> >>>> +/*!
> >>> and the '!' ?
> >>>
> >>>> + * @return true if the card is physically present.
> >>>> + */
> >> What exactly is wrong with @ and !? It's perfectly doxygen-styled.
> > 
> > What part of kernel documentation uses doxygen?
> 
> So then, what's the problem?

Why is it there?  We have a kernel documentation language.
Please use it or plain text.

---
~Randy
