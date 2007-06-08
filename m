Return-Path: <linux-kernel-owner+w=401wt.eu-S1030321AbXFHNJw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030321AbXFHNJw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 09:09:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968343AbXFHNJP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 09:09:15 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:48213 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968151AbXFHNJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 09:09:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=o5vNzn9P2YSkvELMMKCIs0se20UZVpA6GffjEG6+th213F3cFPGxTPk8i4Ivu0oHUIz3Cud5VMYEtlGj2sHdKJogRPWKPB3Snz9JLGpA5EmLBg/KsDkz7IKulTFzftaVAyB4TE/XeCi20q6/+0pSjxwyzspWD4V7Miy1UiBqZfM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 3/2] serverworks: always tune CSB6
Date: Fri, 8 Jun 2007 14:19:18 +0200
User-Agent: KMail/1.9.6
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200706032223.49063.bzolnier@gmail.com> <20070604144018.0dbfa63b@the-village.bc.nu>
In-Reply-To: <20070604144018.0dbfa63b@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706081419.18617.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 04 June 2007, Alan Cox wrote:
> > Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
> > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> 
> Looks good to me - and I can confirm no libata problem reports from us
> always setting modes ourselves.

Thanks for review, added your ACK to the patch.
