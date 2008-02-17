Return-Path: <linux-kernel-owner+w=401wt.eu-S1757393AbYBQRL1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757393AbYBQRL1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 12:11:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753797AbYBQRKh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 12:10:37 -0500
Received: from fk-out-0910.google.com ([209.85.128.188]:57053 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753345AbYBQRKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 12:10:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=MZHPmmCqL/eHYh8DHDy40ZMT0/Rw6ygp7NvKDDw0pZdM9JBT/ck3nzCC8jC5uFCbuHoBkuF2UMWwbHa/QqZ1/OnuQbKd0gTIH3zwWY/fZm//FcnzQzoMPBkU/5J+f+zQqf4fFnPrk9uqVYoU+5b+KxVi3sx6VB88ThkoCfPq++U=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH 03/12] ide: add ide-4drives host driver
Date: Sun, 17 Feb 2008 18:12:40 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20080216163856.10174.72546.sendpatchset@localhost.localdomain> <20080216163911.10174.58246.sendpatchset@localhost.localdomain> <20080216092635.987f002f.randy.dunlap@oracle.com>
In-Reply-To: <20080216092635.987f002f.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802171812.40724.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 16 February 2008, Randy Dunlap wrote:

[...]

> > +You also need to use "probe" kernel paramater for ide-4drives driver
> 
>                                        parameter

thanks, fixed in "take 2"
