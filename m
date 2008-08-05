Return-Path: <linux-kernel-owner+w=401wt.eu-S1762191AbYHESjP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762191AbYHESjP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 14:39:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758102AbYHESi4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 14:38:56 -0400
Received: from casper.infradead.org ([85.118.1.10]:45981 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756644AbYHESiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 14:38:54 -0400
Date: Tue, 5 Aug 2008 11:38:52 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: "Press, Jonathan" <Jonathan.Press@ca.com>
Cc: "Eric Paris" <eparis@redhat.com>, "Greg KH" <greg@kroah.com>,
       <linux-kernel@vger.kernel.org>, <malware-list@lists.printk.net>,
       <linux-security-module@vger.kernel.org>
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a linux
 interfaceforon access scanning
Message-ID: <20080805113852.69302dcb@infradead.org>
In-Reply-To: <2629CC4E1D22A64593B02C43E85553030480743E@USILMS12.ca.com>
References: <1217883616.27684.19.camel@localhost.localdomain>
	<20080804223249.GA10517@kroah.com>
	<1217896374.27684.53.camel@localhost.localdomain>
	<2629CC4E1D22A64593B02C43E855530304807431@USILMS12.ca.com>
	<1217948212.27684.120.camel@localhost.localdomain>
	<2629CC4E1D22A64593B02C43E855530304807436@USILMS12.ca.com>
	<1217956796.11547.12.camel@paris.rdu.redhat.com>
	<20080805103840.1aaa64a5@infradead.org>
	<2629CC4E1D22A64593B02C43E85553030480743B@USILMS12.ca.com>
	<20080805112747.2c3c4650@infradead.org>
	<2629CC4E1D22A64593B02C43E85553030480743E@USILMS12.ca.com>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

you're still top-posting!
Please do not do that.. post your comments below the mail like anyone
else does.


On Tue, 5 Aug 2008 14:34:26 -0400
"Press, Jonathan" <Jonathan.Press@ca.com> wrote:

> But be that as it may...  I don't want to have to use more than one
> interface to get all the events I am interested in.  I want to
> register as a client and listen, and get everything I need from the
> same place.

that's your problem to be honest. Worst case you have a small wrapper
to funnel various sources into one.


> Also, it seems to me that for my purposes, close is discrete enough.
> It tells me that there is now something out there that should be
> looked at.

inotify tells you that. close does not.
