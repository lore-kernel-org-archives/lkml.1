Return-Path: <linux-kernel-owner+w=401wt.eu-S1765371AbXHTU4G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765371AbXHTU4G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 16:56:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764208AbXHTUwv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 16:52:51 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:44303 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1761790AbXHTUwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 16:52:50 -0400
Date: Mon, 20 Aug 2007 16:52:47 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
cc: Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       USB development list <linux-usb-devel@lists.sourceforge.net>
Subject: Re: [linux-usb-devel] [4/4] 2.6.23-rc3: known regressions v2
In-Reply-To: <46C9BAF7.1050409@googlemail.com>
Message-ID: <Pine.LNX.4.44L0.0708201649400.8219-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Aug 2007, Michal Piotrowski wrote:

> Subject         : USB-related oops in sysfs with linux v2.6.23-rc3-50-g28e8351
> References      : http://lkml.org/lkml/2007/8/15/144
> Last known good : ?
> Submitter       : Florin Iucha <florin@iucha.net>
> Caused-By       : ?
> Handled-By      : ?
> Status          : problem is being debugged

A patch was submitted and confirmed to fix the problem:

	http://marc.info/?l=linux-kernel&m=118729528713044&w=2

The patch hasn't been merged yet.  (And incidentally, it wasn't really
an oops -- it was just a warning and stack dump.)

Alan Stern

