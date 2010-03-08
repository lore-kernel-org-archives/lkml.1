Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755323Ab0CHPoY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 10:44:24 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:48224 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753412Ab0CHPoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 10:44:21 -0500
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <James.Bottomley@suse.de>, Tejun Heo <tj@kernel.org>,
       "linux-ide\@vger.kernel.org" <linux-ide@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Daniel Taylor <Daniel.Taylor@wdc.com>, Jeff Garzik <jeff@garzik.org>,
       Mark Lord <kernel@teksavvy.com>, tytso@mit.edu,
       "H. Peter Anvin" <hpa@zytor.com>, hirofumi@mail.parknet.co.jp,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, irtiger@gmail.com,
       Matthew Wilcox <matthew@wil.cx>, aschnell@suse.de, knikanth@suse.de,
       jdelvare@suse.de
Subject: Re: ATA 4 KiB sector issues.
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <4B947393.2050002@kernel.org>
	<1268031640.4389.11.camel@mulgrave.site>
	<yq1vdd6bzgz.fsf@sermon.lab.mkp.net>
	<yq1mxyibz7o.fsf@sermon.lab.mkp.net>
Date: Mon, 08 Mar 2010 10:41:57 -0500
In-Reply-To: <yq1mxyibz7o.fsf@sermon.lab.mkp.net> (Martin K. Petersen's
	message of "Mon, 08 Mar 2010 10:38:35 -0500")
Message-ID: <yq1iq96bz22.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4B951AF7.0220:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Martin" == Martin K Petersen <martin.petersen@oracle.com> writes:

>>>>> "Martin" == Martin K Petersen <martin.petersen@oracle.com> writes:
Martin> There are 4 KB LBS SSDs out there but in general the industry is
Martin> sticking to ATA for local boot.

Martin> Thus implying that ATA doesn't support 4 KB LBS, just that
Martin> people stick to the tried-and-true 512.

*sigh* I haven't had my breakfast tea yet...

What I meant to say was that I know ATA supports 4 KB LBS and that
nobody appears to care about it.

-- 
Martin K. Petersen	Oracle Linux Engineering
