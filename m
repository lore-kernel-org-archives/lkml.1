Return-Path: <linux-kernel-owner+w=401wt.eu-S1758983AbZKYSXh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758983AbZKYSXh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 13:23:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754290AbZKYSXh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 13:23:37 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:58833 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753321AbZKYSXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 13:23:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=mBfpEpEMehKbnDdUs7ACd9VZFrvMr7MuHr4TZ7ri7EdeIkXeGEx3WMkm1yxY+gU7AQ
         Nq/uBE/Zch5Ypyn1whvWT5MH0gOARghl7LZmNWtNWCXskjZrxiv4n7d2AvZLKBdxXvSN
         SzvnncLiCosf6RCyfxQwRiemltHYc3QPaaz/o=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 82/86] pata_via: clear UDMA transfer mode bit for PIO and MWDMA
Date: Wed, 25 Nov 2009 19:10:06 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-0.1-desktop; KDE/4.3.1; x86_64; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20091125170218.5446.13513.sendpatchset@localhost> <200911251858.38491.bzolnier@gmail.com> <20091125180648.6ab19725@lxorguk.ukuu.org.uk>
In-Reply-To: <20091125180648.6ab19725@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911251910.06924.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 November 2009 07:06:48 pm Alan Cox wrote:
> > Do you really find such tidy patch hard to review?
> 
> When doing it at speed - yes.

Do you review everybody else patches 'at speed' or only mine?

--
Bartlomiej Zolnierkiewicz
