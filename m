Return-Path: <linux-kernel-owner+w=401wt.eu-S933124AbZKYRrL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933124AbZKYRrL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 12:47:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932659AbZKYRrH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 12:47:07 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:20577 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933017AbZKYRrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 12:47:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=poM06IMPsd2q75PCRAQ6ails/38FbnNxKUGHIQUdiSAamMVFkbZRZuyikiak5x2fQz
         9t7uy7ilc+pHMrPi6IFVShjjK8VAovpJssikKMmAJEFf0S+4fNHsr8wNTpRCn2lGkYZf
         CXGt8bLmXzMlyaax6VUa6utgJnwAcgxMerRFw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 48/86] pata_legacy: add pointers to QDI65x0 documentation
Date: Wed, 25 Nov 2009 18:44:59 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-0.1-desktop; KDE/4.3.1; x86_64; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20091125170218.5446.13513.sendpatchset@localhost> <20091125170802.5446.46013.sendpatchset@localhost> <20091125173852.71fcdf9d@lxorguk.ukuu.org.uk>
In-Reply-To: <20091125173852.71fcdf9d@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911251844.59772.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 November 2009 06:38:52 pm Alan Cox wrote:
> > + *	QDI65x0 probe code based on drivers/ide/legacy/qd65xx.c
> > + *	Rewritten from the work of Colten Edwards <pje120@cs.usask.ca> by
> > + *	Samuel Thibault <samuel.thibault@ens-lyon.org>
> 
> It's not drivers/ide/legacy/qd65xx.c - because you moved it back in the
> old IDE code.

It was the correct path/driver when the aforementioned code was added.

--
Bartlomiej Zolnierkiewicz
