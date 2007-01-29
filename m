Return-Path: <linux-kernel-owner+w=401wt.eu-S1752615AbXA2UxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752615AbXA2UxV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 15:53:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752609AbXA2UxV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 15:53:21 -0500
Received: from an-out-0708.google.com ([209.85.132.245]:57260 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608AbXA2UxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 15:53:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=iJ2XySs45V37p9qQBkonGu86SvZgOH4vkTZx7azYwXtx3P3z2NKvSV68p82uv0tSb6nNdfw605JcqEdBo/cOjpm7zsi8HSNgK0XTThcaWqOXb1CdwFFTtd/hpH3oC0x/aagJnrNY++cEySaYoif2nwV8M2qCvTfku6s+dE+N/F4=
Message-ID: <8d158e1f0701291253u38607480m597d32815143c5e6@mail.gmail.com>
Date: Mon, 29 Jan 2007 21:53:19 +0100
From: "Patrick Ale" <patrick.ale@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: Boot problems with pata_via driver
In-Reply-To: <8d158e1f0701282332m3e22a649s621abc258c6103d5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8d158e1f0701280347l1d778528la0d69647726485d6@mail.gmail.com>
	 <20070128231147.GA6017@stusta.de>
	 <8d158e1f0701282330o3591a226lb664644ffdb025f0@mail.gmail.com>
	 <8d158e1f0701282332m3e22a649s621abc258c6103d5@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Okay so, I unplugged the keyboard the moment I selected a kernel to boot.
The last thing i see on my screen, regarding SCSI is:

scsi 0:0:0:0: Direct-Access       ATA      WDC WD2000JB-00G 08.0 PQ: 0 ANSI: 5
scsi 1:0:0:0 CD-ROM               AOPEN DUW1608/ARR         A060 PW: 0 ANSI: 5


then later on:

VFS: Cannot open root device "sda3" or unknown-block(0,0)
Please append a correct "root=" boot option
Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(0,0)
