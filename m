Return-Path: <linux-kernel-owner+w=401wt.eu-S1752216AbXDZPJO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752216AbXDZPJO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 11:09:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753156AbXDZPJN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 11:09:13 -0400
Received: from hancock.steeleye.com ([71.30.118.248]:46048 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752233AbXDZPJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 11:09:12 -0400
Subject: Re: [PATCH] Block layer: separate out queue-oriented ioctls
From: James Bottomley <James.Bottomley@SteelEye.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Joerg Schilling <Joerg.Schilling@fokus.fraunhofer.de>, dougg@torque.net,
       linux-kernel@vger.kernel.org, jens.axboe@oracle.com
In-Reply-To: <Pine.LNX.4.44L0.0704261102010.3552-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.0704261102010.3552-100000@iolanthe.rowland.org>
Content-Type: text/plain
Date: Thu, 26 Apr 2007 11:08:38 -0400
Message-Id: <1177600118.6284.121.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-04-26 at 11:04 -0400, Alan Stern wrote:
> On Thu, 26 Apr 2007, Joerg Schilling wrote:
> 
> > Any chance to that this bug will be fixed anytime soon?
> > 
> > The Bug has been reported February 2004 but is still not fixed in sg.c
> > Is Linux development really sooooo slow?
> 
> Douglas Gilbert has signed off on the patch.  There doesn't appear to have 
> been any change to the scsi-misc-2.6 GIT tree recently, but hopefully the 
> changes will appear in the 2.6.22 kernel.
> 
> James, is that correct?

Yes, it's in my local tree 

James


