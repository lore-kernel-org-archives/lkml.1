Return-Path: <linux-kernel-owner+w=401wt.eu-S1752144AbZL2UAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752144AbZL2UAk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 15:00:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752065AbZL2UAk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 15:00:40 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:56300 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023AbZL2UAi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 15:00:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=W+B6SGkWNR/wh2jWWnkcWynPs3Rl30NRYDsZOMFPMT0l4rvBF7is6C05PlZmQSZs84
         z+BelyCAkiq0FF2lavVPhr7kBurbMcfUz1WdLW7C+eOdXbqlkbAIQD7+oS6pBM7rQpKk
         EIWsNANERZicYmkTlMH6bO4dt4nNyZwj+TyqA=
MIME-Version: 1.0
In-Reply-To: <LptzGUUXbTK.A.MSF.ymhOLB@chimera>
References: <LptzGUUXbTK.A.MSF.ymhOLB@chimera>
Date: Tue, 29 Dec 2009 21:00:35 +0100
Message-ID: <b170af450912291200r73a56d55n5e9a68043a503907@mail.gmail.com>
Subject: Re: 2.6.33-rc2: Reported regressions from 2.6.32
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       Linux SCSI List <linux-scsi@vger.kernel.org>,
       Linux Wireless List <linux-wireless@vger.kernel.org>,
       DRI <dri-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/12/29 Rafael J. Wysocki <rjw@sisk.pl>:
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=14910
> Subject         : Stable version 2.6.32.2 broke my KMS Radeon setup
> Submitter       : Ruud Linders <kernelml@xs4all.nl>
> Date            : 2009-12-20 12:02 (10 days old)
> References      : http://marc.info/?l=linux-kernel&m=126131105608871&w=4

Has patch (I think it was even submitted to Linus).

-- 
Rafał
