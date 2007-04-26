Return-Path: <linux-kernel-owner+w=401wt.eu-S1031252AbXDZPEO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031252AbXDZPEO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 11:04:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031243AbXDZPEO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 11:04:14 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:58260 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1031253AbXDZPEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 11:04:13 -0400
Date: Thu, 26 Apr 2007 11:04:12 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Joerg Schilling <Joerg.Schilling@fokus.fraunhofer.de>
cc: dougg@torque.net, <linux-kernel@vger.kernel.org>, <jens.axboe@oracle.com>,
       <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] Block layer: separate out queue-oriented ioctls
In-Reply-To: <46306ea4.nlqf3c05IYBhob1c%Joerg.Schilling@fokus.fraunhofer.de>
Message-ID: <Pine.LNX.4.44L0.0704261102010.3552-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Apr 2007, Joerg Schilling wrote:

> Any chance to that this bug will be fixed anytime soon?
> 
> The Bug has been reported February 2004 but is still not fixed in sg.c
> Is Linux development really sooooo slow?

Douglas Gilbert has signed off on the patch.  There doesn't appear to have 
been any change to the scsi-misc-2.6 GIT tree recently, but hopefully the 
changes will appear in the 2.6.22 kernel.

James, is that correct?

Alan Stern

