Return-Path: <linux-kernel-owner+w=401wt.eu-S1754290AbZBQVFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754290AbZBQVFb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 16:05:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752289AbZBQVFM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 16:05:12 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:57680 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751856AbZBQVFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 16:05:11 -0500
Date: Tue, 17 Feb 2009 16:05:09 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Jiri Slaby <jirislaby@gmail.com>, Oliver Neukum <oliver@neukum.org>
cc: Laurent Riffard <laurent.riffard@free.fr>, <linux-input@vger.kernel.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, <linux-next@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: linux-next: USB mouse won't work after resume.
In-Reply-To: <200902172142.57302.oliver@neukum.org>
Message-ID: <Pine.LNX.4.44L0.0902171602510.18399-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Feb 2009, Oliver Neukum wrote:

> Please try the attached patch.
> 
> 	Regards
> 		Oliver

Jiri,

It seems likely that you are seeing the same problem as Laurent in your
mmotm 2009-02-10-16-35 kernel.  You should try Oliver's patch,
available here:

	http://marc.info/?l=linux-usb&m=123490330326229&w=2

Alan Stern

