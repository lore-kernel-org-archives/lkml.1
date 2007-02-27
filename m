Return-Path: <linux-kernel-owner+w=401wt.eu-S1750733AbXB0NAd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750733AbXB0NAd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 08:00:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750820AbXB0NAc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 08:00:32 -0500
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:35852 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750733AbXB0NAc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 08:00:32 -0500
Date: Tue, 27 Feb 2007 15:00:29 +0200 (EET)
From: Meelis Roos <mroos@linux.ee>
To: Adrian Bunk <bunk@stusta.de>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: 2.6.21-rc1: known regressions (v2) (part 1)
In-Reply-To: <20070226220152.GA29575@stusta.de>
Message-ID: <Pine.SOC.4.64.0702271459040.8348@math>
References: <Pine.LNX.4.64.0702202043280.4043@woody.linux-foundation.org>
 <20070226220152.GA29575@stusta.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Subject    : ata-piix ACPI errors (40/80 pin cable mix)
> References : http://lkml.org/lkml/2007/2/22/159
> Submitter  : Meelis Roos <mroos@linux.ee>
> Status     : unknown

Still appears, but this does not seem to be 40/80 pin cable problem to 
be but rather ata-piix calling some acpi methods and this rulsts in acpi 
errors.

-- 
Meelis Roos (mroos@linux.ee)
