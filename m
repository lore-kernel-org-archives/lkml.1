Return-Path: <linux-kernel-owner+w=401wt.eu-S1754460AbZHZIrQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754460AbZHZIrQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 04:47:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755154AbZHZIrP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 04:47:15 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:1970 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754205AbZHZIrO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 04:47:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=K+1NAIXn/Un0eRRzgvHWmbPfYxPvqhoO/OVvh++lvNTjMUIJHM94ppW4zDVaGWfwMH
         QgrQROTFCYLvWBTkChp9pWZG9KpLtIdf3dD7Fo4aMT+eOz+5Ir10hNbjCiBTRnvmXuxn
         Hz5koSpEQTX4StGKOby3/67SIPA/9XindCn68=
MIME-Version: 1.0
In-Reply-To: <JuOd1ZASH0B.A.YGB.0zGlKB@chimera>
References: <JuOd1ZASH0B.A.YGB.0zGlKB@chimera>
Date: Wed, 26 Aug 2009 10:47:13 +0200
Message-ID: <b170af450908260147o60427997ne6b9872198893c41@mail.gmail.com>
Subject: Re: 2.6.31-rc7-git2: Reported regressions 2.6.29 -> 2.6.30
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       DRI <dri-devel@lists.sourceforge.net>,
       Linux SCSI List <linux-scsi@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       Linux Wireless List <linux-wireless@vger.kernel.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Linux ACPI <linux-acpi@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/8/25 Rafael J. Wysocki <rjw@sisk.pl>:
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=13514
> Subject         : acer_wmi causes stack corruption
> Submitter       : Rus <harbour@sfinx.od.ua>
> Date            : 2009-06-12 08:13 (75 days old)

It has patch, just Len doesn't seem to... don't know, read the topic?
http://patchwork.kernel.org/patch/29082/

Can we ping Len somehow to push this patch directly to Linus's tree?

-- 
Rafał Miłecki
