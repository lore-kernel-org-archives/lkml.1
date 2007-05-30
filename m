Return-Path: <linux-kernel-owner+w=401wt.eu-S1761696AbXE3WXo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761696AbXE3WXo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 18:23:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759225AbXE3WXB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 18:23:01 -0400
Received: from an-out-0708.google.com ([209.85.132.245]:51039 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755981AbXE3WXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 18:23:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=EBfozZIAVLGxrN8ZqaL/BILm9GEWbSqNEXyKK5SNePc+UqU5yO4U0MW9CKWBYWBQpkRGX0X+ZTdzTAOPBHku/d1HO4L2MUiyQ9KdPDR/zCKMxlpg1cbFFOynIjgY78zws39RRxcaKezriqCZC8QVvOyebpDpSQsySmUnZalK1HA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Junio C Hamano <junkio@cox.net>
Subject: Re: [PATCH 2/3] mips au1xxx_ide.h: use NULL as firmware-revision wildcard.
Date: Wed, 30 May 2007 22:45:19 +0200
User-Agent: KMail/1.9.6
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Dave Jones <davej@redhat.com>
References: <20070521145042.GA6957@redhat.com> <200705282141.42507.bzolnier@gmail.com> <7vy7j87ddp.fsf@assigned-by-dhcp.cox.net>
In-Reply-To: <7vy7j87ddp.fsf@assigned-by-dhcp.cox.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705302245.19939.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 May 2007, Junio C Hamano wrote:
> This updates the DMA whitelist in MIPS specific au1xxx ide
> driver to use NULL instead of "ALL" as the wildcard.
> 
> Signed-off-by: Junio C Hamano <junkio@cox.net>

applied
