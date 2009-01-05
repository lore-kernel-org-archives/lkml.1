Return-Path: <linux-kernel-owner+w=401wt.eu-S1753065AbZAET3E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753065AbZAET3E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 14:29:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753230AbZAET2j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 14:28:39 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:25902 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752825AbZAET2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 14:28:38 -0500
To: Rob Landley <rob@landley.net>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
       Pavel Machek <pavel@suse.cz>, Sitsofe Wheeler <sitsofe@yahoo.com>,
       Duane Griffin <duaneg@dghda.com>, Valdis.Kletnieks@vt.edu,
       Martin =?utf-8?Q?MOKREJ=C5=A0?= <mmokrejs@ribosome.natur.cuni.cz>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org
Subject: Re: document ext3 requirements
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <fa.pmCH9X+XujDl6RH6/TpkNtsTnbk@ifi.uio.no>
	<200901042149.27655.rob@landley.net>
	<20090105111913.47a8d1a5@lxorguk.ukuu.org.uk>
	<200901051300.09169.rob@landley.net>
Date: Mon, 05 Jan 2009 14:27:33 -0500
In-Reply-To: <200901051300.09169.rob@landley.net> (Rob Landley's message of "Mon\, 5 Jan 2009 13\:00\:07 -0600")
Message-ID: <yq1ocyl1rkq.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Source-IP: acsmt701.oracle.com [141.146.40.71]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010208.49625F2B.0004:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Rob" == Rob Landley <rob@landley.net> writes:

Rob> On Monday 05 January 2009 05:19:13 Alan Cox wrote:
>> You could of course just learn to use the functions the kernel
>> provides.  If you want to recover disk blocks without retrying you
>> can do that via SG_IO. If you want to adjust the timeout and retry
>> levels you can do that too via sysfs.

Rob> Good to know, but "my laptop hard drive just died" is not the
Rob> optimal time to learn these sorts of things.

http://www.garloff.de/kurt/linux/ddrescue/

-- 
Martin K. Petersen	Oracle Linux Engineering

