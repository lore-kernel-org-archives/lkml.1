Return-Path: <linux-kernel-owner+w=401wt.eu-S1756343AbZJSOOv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756343AbZJSOOv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 10:14:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756325AbZJSOOu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 10:14:50 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:35955 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756267AbZJSOOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 10:14:49 -0400
Date: Mon, 19 Oct 2009 10:14:54 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Felipe Contreras <felipe.contreras@gmail.com>
cc: Jiri Kosina <jkosina@suse.cz>, <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Sarah Sharp <sarah.a.sharp@linux.intel.com>,
       <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 1/7] usb: trivial cleanups
In-Reply-To: <94a0d4530910190703q1a0e2a6ar4cf74a68d7bc339f@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.0910191014160.3899-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Oct 2009, Felipe Contreras wrote:

> >> AFAIK the code is perfectly correct as it is, I think the fact that
> >> gcc 4.4 complains is a bug on gcc side.
> >
> > Yes, it is a well-known bug in gcc.  Other places in the kernel get
> > similar warnings.
> 
> So gcc guys are aware of this? Is there a bug report or something?

I don't know.  You should ask them.

Alan Stern

