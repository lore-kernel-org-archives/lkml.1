Return-Path: <linux-kernel-owner+w=401wt.eu-S965469AbXDBNyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965469AbXDBNyR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 09:54:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965475AbXDBNyR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 09:54:17 -0400
Received: from netrider.rowland.org ([192.131.102.5]:4744 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S965469AbXDBNyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 09:54:16 -0400
Date: Mon, 2 Apr 2007 09:54:13 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Joerg Schilling <schilling@fokus.fraunhofer.de>
cc: dougg@torque.net, James Bottomley <James.Bottomley@steeleye.com>,
       <jens.axboe@oracle.com>,
       SCSI development list <linux-scsi@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Block layer: separate out queue-oriented ioctls Re:
 [PATCH] Block layer: separate out queue-oriented ioctls
In-Reply-To: <200704020828.l328SICc009264@burner.fokus.fraunhofer.de>
Message-ID: <Pine.LNX.4.44L0.0704020951180.1743-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Apr 2007, Joerg Schilling wrote:

> Hi,
> 
> this is a repost as I like to know the current state of the problem...
> 
> The USB DMA size problem is known to exist on Linux since February 2004.
> I am still in hope that there will be a fix soon.

Me too.  I submitted the most recent version of the patch (labelled as857) 
over a month ago and have received essentially no feedback on it.

Douglas, James...  What's the story?

Alan Stern

