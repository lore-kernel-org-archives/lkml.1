Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932208Ab0CIDXt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 22:23:49 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:50612 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932183Ab0CIDXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 22:23:45 -0500
To: Tejun Heo <tj@kernel.org>
Cc: Mike Snitzer <snitzer@redhat.com>,
       "Martin K. Petersen" <martin.petersen@oracle.com>,
       "linux-ide\@vger.kernel.org" <linux-ide@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Daniel Taylor <Daniel.Taylor@wdc.com>, Jeff Garzik <jeff@garzik.org>,
       Mark Lord <kernel@teksavvy.com>, tytso@mit.edu,
       "H. Peter Anvin" <hpa@zytor.com>, hirofumi@mail.parknet.co.jp,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, irtiger@gmail.com,
       Matthew Wilcox <matthew@wil.cx>, aschnell@suse.de, knikanth@suse.de,
       jdelvare@suse.de, Karel Zak <kzak@redhat.com>,
       Jim Meyering <jim@meyering.net>
Subject: Re: ATA 4 KiB sector issues.
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <4B947393.2050002@kernel.org> <yq1zl2ic058.fsf@sermon.lab.mkp.net>
	<170fa0d21003081134g491034e5v4aad4d43853e48ec@mail.gmail.com>
	<4B95B843.6030900@kernel.org>
Date: Mon, 08 Mar 2010 22:20:41 -0500
In-Reply-To: <4B95B843.6030900@kernel.org> (Tejun Heo's message of "Tue, 09
	Mar 2010 11:53:55 +0900")
Message-ID: <yq17hpm89km.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4B95BEFF.000F:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Tejun" == Tejun Heo <tj@kernel.org> writes:

>> http://people.redhat.com/msnitzer/docs/io-limits.txt

Tejun> Ah... this is great.  I'll link the doc and shamelessly steal
Tejun> parts of it if that's okay with you.

There's also this one:

    http://oss.oracle.com/~mkp/docs/linux-advanced-storage.pdf

It is more aimed at storage vendors than end users, though.

-- 
Martin K. Petersen	Oracle Linux Engineering
