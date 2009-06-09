Return-Path: <linux-kernel-owner+w=401wt.eu-S1763212AbZFIKjQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763212AbZFIKjQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 06:39:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760432AbZFIKX2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 06:23:28 -0400
Received: from kroah.org ([198.145.64.141]:32954 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760764AbZFIKX1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 06:23:27 -0400
Date: Tue, 9 Jun 2009 03:18:12 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Brian King <brking@linux.vnet.ibm.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: linux-next: manual merge of the driver-core tree with the scsi
	tree
Message-ID: <20090609101812.GA27305@kroah.com>
References: <20090609190415.3bfba32d.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090609190415.3bfba32d.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 09, 2009 at 07:04:15PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the driver-core tree got a conflict in
> drivers/scsi/ibmvscsi/ibmvscsi.c between commit
> 126c5cc37e682e7c5ae96754994b1cb50c2d0cb5 ("[SCSI] ibmvscsi: Add support
> for capabilities MAD") from the scsi tree and commit
> 1e87031283511c775454ecd57f16a1a2de30aafa ("ibmvscsi: gadget: at91_udc:
> remove driver_data direct access of struct device") from the driver-core
> tree.
> 
> Just context changes.  I fixed it up (see below) and can carry the fix as
> necessary.

The fix looks fine, thanks for doing this.

greg k-h
