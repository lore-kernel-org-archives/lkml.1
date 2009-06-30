Return-Path: <linux-kernel-owner+w=401wt.eu-S1755821AbZF3Fhl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755821AbZF3Fhl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 01:37:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752553AbZF3Fhd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 01:37:33 -0400
Received: from mail.gmx.net ([213.165.64.20]:59194 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752231AbZF3Fhc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 01:37:32 -0400
X-Authenticated: #1512929
X-Provags-ID: V01U2FsdGVkX18kOq9iKxokoqGzYRzggtYB85PMzl4UU50KYRPqD+
	f2Ku58VgI8yzoK
Message-ID: <4A49A49C.10104@warlich.name>
Date: Tue, 30 Jun 2009 07:37:32 +0200
From: Christof Warlich <christof@warlich.name>
Organization: Warlich Consulting
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Robert Hancock <hancockrwd@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: "EXT3-fs error" after resume from s2ram
References: <4A4771FD.1020207@warlich.name> <4A480859.5010206@gmail.com> <4A48C799.2010102@warlich.name> <4A495C2D.1040706@gmail.com>
In-Reply-To: <4A495C2D.1040706@gmail.com>
Content-Type: multipart/mixed;
 boundary="------------050103060304080909090905"
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.68
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050103060304080909090905
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

No, really nothing else but these EXT3-fs error messages are printed to vt1,
and as the disk is not accessible,  nothing can be found in 
/var/log/kern.log either.

With respect to libata and SCSI and on a normal system boot, 
/var/log/kern.log just
contains:

SCSI subsystem initialized
libata version 3.00 loaded.

so nothing helpful either.  Do you want me to send an entire boot - 
suspend cycle
from /var/log/kern.log?

Robert Hancock schrieb:
> Hmm.. How about any normal output from the libata, scsi, etc? Seems 
> odd you wouldn't get anything unusual there if the file system was 
> complaining..


--------------050103060304080909090905
Content-Type: text/x-vcard; charset=utf-8;
 name="christof.vcf"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="christof.vcf"

begin:vcard
fn:Christof Warlich
n:Warlich;Christof
org:Warlich Consulting
adr:;;Am Haselhang 7;Hilpoltstein;Bayern;91161;Deutschland
email;internet:christof@warlich.name
tel;work:09174/492914
tel;home:09174/492914
x-mozilla-html:TRUE
url:www.warlich.name
version:2.1
end:vcard


--------------050103060304080909090905--
