Return-Path: <linux-kernel-owner+w=401wt.eu-S1757146AbZFQRMz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757146AbZFQRMz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 13:12:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754467AbZFQRMp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 13:12:45 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:50411 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753745AbZFQRMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 13:12:45 -0400
Date: Wed, 17 Jun 2009 13:12:46 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Boaz Harrosh <bharrosh@panasas.com>
cc: Hannes Reinecke <hare@suse.de>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Greg KH <greg@kroah.com>,
       SCSI development list <linux-scsi@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] driver core: remove unheeded warning about driver methods
In-Reply-To: <4A391909.2090609@panasas.com>
Message-ID: <Pine.LNX.4.44L0.0906171311430.2820-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Jun 2009, Boaz Harrosh wrote:

> There was a proper and simple fix for that problem here:
> http://www.spinics.net/lists/kernel/msg860289.html
> 
> Hannes please re push this patch properly. We want it ;)

I have to agree; Hannes's patch is a lot better.  Send it in!

Alan Stern

