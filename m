Return-Path: <linux-kernel-owner+w=401wt.eu-S932618AbYBZW0b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932618AbYBZW0b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 17:26:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765088AbYBZWXp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 17:23:45 -0500
Received: from nf-out-0910.google.com ([64.233.182.189]:23797 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764685AbYBZWXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 17:23:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=uN/mXOujiVYg9WI1OL/aUSfLs0Fl6/d+89V3Jbcmyz9m1+9aPb5/lhS2wdAUrkxTdVd1yTGj0c40Sa3eZP7uXjbZe+fZVylv7Um8OYy81hIDsFq1QoxrBuZZn3wTwwngEVBf1okV6UwRnblBs1xy5bacEu1rzc0XcyWfHQLPfMs=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Paolo Ciarrocchi" <paolo.ciarrocchi@gmail.com>
Subject: Re: [PATCH 08/10] IDE: Coding Style fixes to drivers/ide/pci/generic.c
Date: Tue, 26 Feb 2008 22:22:44 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: "Cyrill Gorcunov" <gorcunov@gmail.com>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>,
       linux-ide <linux-ide@vger.kernel.org>
References: <20080223150547.5256e734@paolo-desktop> <20080223142909.GD6747@cvg> <4d8e3fd30802230637h3c16e1bm4d99341c9cc8d70c@mail.gmail.com>
In-Reply-To: <4d8e3fd30802230637h3c16e1bm4d99341c9cc8d70c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802262222.44162.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 23 February 2008, Paolo Ciarrocchi wrote:
> > | -/**
> > | +/*
> > ^^^^^^^
> >
> > Hi Paolo, it seems you just broke kdoc structure
> 
> thank you for your comment, i didn't know that.
> Won't happen in future patches.
> Bart, can you fix that or do you want me to re-create the series?

I fixed this issue in all patches while merging them.

Thanks,
Bart
