Return-Path: <linux-kernel-owner+w=401wt.eu-S1759940AbZKZL6Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759940AbZKZL6Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 06:58:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759699AbZKZL6X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 06:58:23 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:38603 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754795AbZKZL6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 06:58:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=rCnTta7y6TND+Z9la8beSzbOYTu1E0V2FfW7tdMgWGli603R9YbV0BmvnQIp2Qd48W
         XdXJzY7b5Y9DWmC4TZSbQP/HZJ2ViH33H0IMI3JIa1TVDRWgm8hU/O0YtrymEHqoOgSb
         vV0VoaGCyBGfsnEqeWxR09cFtV6p/AeEJ1yVg=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 62/86] pata_pdc202xx_old: document known issues
Date: Thu, 26 Nov 2009 12:57:01 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-0.1-desktop; KDE/4.3.1; x86_64; ; )
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20091125170218.5446.13513.sendpatchset@localhost> <200911252302.18213.bzolnier@gmail.com> <4B0DF2B2.20605@garzik.org>
In-Reply-To: <4B0DF2B2.20605@garzik.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911261257.01356.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 November 2009 04:14:58 am Jeff Garzik wrote:
> On 11/25/2009 05:02 PM, Bartlomiej Zolnierkiewicz wrote:
> > On Wednesday 25 November 2009 09:38:27 pm Jeff Garzik wrote:
> >> On 11/25/2009 01:29 PM, Bartlomiej Zolnierkiewicz wrote:
> >>> I think it is the best to leave up to the driver maintainer
> >>> (once we find out who this person is, MAINTAINERS file still
> >>> lacks info about PATA drivers in -rc8).
> >>
> >>
> >> The important thing is taking two minutes to write a relevant comment,
> >
> > If you want something changed in the code of pata_pdc202xx_old feel free to
> > make said changes.  I'm neither the author nor the maintainer of this driver.
> 
> You don't need to be the author or maintainer of a driver to submit changes.

I have neither any obligation nor any motivation to do it and you've already
wasted much more than said two minutes for everybody.

--
Bartlomiej Zolnierkiewicz
