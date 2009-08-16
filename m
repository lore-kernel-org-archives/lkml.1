Return-Path: <linux-kernel-owner+w=401wt.eu-S1750942AbZHPNng@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750942AbZHPNng (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 09:43:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750844AbZHPNng
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 09:43:36 -0400
Received: from mx2.redhat.com ([66.187.237.31]:58151 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750805AbZHPNnf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 09:43:35 -0400
Date: Sun, 16 Aug 2009 16:42:18 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: consistent use of __u8 in scsi/scsi.h
Message-ID: <20090816134218.GA5224@redhat.com>
References: <20090729111114.GA15239@redhat.com> <1248875763.3900.1.camel@mulgrave.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1248875763.3900.1.camel@mulgrave.site>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 29, 2009 at 08:56:03AM -0500, James Bottomley wrote:
> On Wed, 2009-07-29 at 14:11 +0300, Michael S. Tsirkin wrote:
> > scsi/scsi.h is exported to userspace, so it should
> > use __u8 instead of u8 as other userspace-visible headers do.
> 
> Actually, can we just put a hold on this until we decide what we're
> doing with exporting include/scsi.

Any update?

