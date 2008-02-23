Return-Path: <linux-kernel-owner+w=401wt.eu-S1759068AbYBWOhV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759068AbYBWOhV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 09:37:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754738AbYBWOhF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 09:37:05 -0500
Received: from wf-out-1314.google.com ([209.85.200.171]:23045 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754147AbYBWOhC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 09:37:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=JbCJYHUv5YnVJUmZTpENWsZW5Tih9AEWQJ7ARhO4HY3aITNYwt9yEi8zRzEDB+uDOT8KuhJXGtSjz9npxEonb983KMHf8Q7ylN0IYZBg4kI+ijGpLJsoCpG05qu/I4Us89Tss/VXfMXS2wxXAiJUONCfNW+fSpxtXFqfYUcuKVI=
Message-ID: <4d8e3fd30802230637h3c16e1bm4d99341c9cc8d70c@mail.gmail.com>
Date: Sat, 23 Feb 2008 18:07:01 +0330
From: "Paolo Ciarrocchi" <paolo.ciarrocchi@gmail.com>
To: "Cyrill Gorcunov" <gorcunov@gmail.com>
Subject: Re: [PATCH 08/10] IDE: Coding Style fixes to drivers/ide/pci/generic.c
Cc: "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>,
       linux-ide <linux-ide@vger.kernel.org>
In-Reply-To: <20080223142909.GD6747@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080223150547.5256e734@paolo-desktop> <20080223142909.GD6747@cvg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> | -/**
> | +/*
> ^^^^^^^
>
> Hi Paolo, it seems you just broke kdoc structure

thank you for your comment, i didn't know that.
Won't happen in future patches.
Bart, can you fix that or do you want me to re-create the series?

Ciao,
--
Paolo
http://paolo.ciarrocchi.googlepages.com/
