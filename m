Return-Path: <linux-kernel-owner+w=401wt.eu-S1752493AbXHAVE7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752493AbXHAVE7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 17:04:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752499AbXHAVD6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 17:03:58 -0400
Received: from mu-out-0910.google.com ([209.85.134.186]:49558 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752347AbXHAVDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 17:03:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=mjhcW8U9Dxp095gRraygG8du1AmKMQsw+fHxlakvvbaDZedib82eJYtmz8jN80RHjqcUTmS1mpH+VT9AGRavsTr+BYo/g4Kiik5sjvYPrlsCaYEMMWGrebqaCkurvvk5Or4PASKLVQ8nJG7bXAB3qYik7Lx25flLhE4L/Iq9nSA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Subject: Re: [PATCH 31] drivers/scsi/ide-scsi.c: kmalloc + memset conversion to kzalloc
Date: Wed, 1 Aug 2007 23:02:34 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org
References: <200707311845.48807.m.kozlowski@tuxland.pl> <200707312001.58138.m.kozlowski@tuxland.pl>
In-Reply-To: <200707312001.58138.m.kozlowski@tuxland.pl>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200708012302.34205.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 31 July 2007, Mariusz Kozlowski wrote:
> Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
> 
>  drivers/scsi/ide-scsi.c | 34642 -> 34536 (-106 bytes)
>  drivers/scsi/ide-scsi.o | 171728 -> 171524 (-204 bytes)
> 
>  drivers/scsi/ide-scsi.c |   10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)

applied
