Return-Path: <linux-kernel-owner+w=401wt.eu-S1762033AbZAFWlf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762033AbZAFWlf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 17:41:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759302AbZAFWeT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 17:34:19 -0500
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:1506 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759260AbZAFWeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 17:34:16 -0500
Date: Tue, 6 Jan 2009 23:33:41 +0100
From: Folkert van Heusden <folkert@vanheusden.com>
To: alan@lxorguk.ukuu.org.uk
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       udovdh@xs4all.nl
Subject: Re: 2.6.29 -mm merge plans
Message-ID: <20090106223341.GR1474@vanheusden.com>
References: <20090105004300.19ed52d1.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090105004300.19ed52d1.akpm@linux-foundation.org>
Organization: www.unixexpert.nl
X-Chameleon-Return-To: folkert@vanheusden.com
X-Xfmail-Return-To: folkert@vanheusden.com
X-Phonenumber: +31-6-41278122
X-URL: http://www.vanheusden.com/
X-PGP-KeyID: 1F28D8AE
X-GPG-fingerprint: AC89 09CE 41F2 00B4 FCF2  B174 3019 0E8C 1F28 D8AE
X-Key: http://pgp.surfnet.nl:11371/pks/lookup?op=get&search=0x1F28D8AE
Read-Receipt-To: <folkert@vanheusden.com>
Reply-By: Wed Jan  7 16:30:58 CET 2009
X-Message-Flag: www.vanheusden.com
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> linuxpps-core-support.patch
> linuxpps-core-support-sysfs-not-needed-variables-removed.patch
> pps-userland-header-file-for-pps-api.patch
> pps-documentation-programs-and-examples.patch
> pps-linuxpps-clients-support.patch
> ldisc-new-dcd_change-method-for-line-disciplines.patch
> #ldisc-n_tty-export-all-n_tty-ldisc-methods.patch
> #ldisc-n_tty-export-all-n_tty-ldisc-methods-fix.patch
> #pps-serial-clients-support.patch
> #pps-serial-clients-support-avoid-noisy-compilation-on-64bits-architecture.patch
> pps-parallel-port-clients-support.patch
> #pps-low-level-irq-timestamps-recording.patch: don't merge!
> #pps-low-level-irq-timestamps-recording.patch
> 
>   Some of PPS.  Will merge.  Some stuff got left out because Alan was
>   being cryptic.  We'll get there.

What are the current problems with this patch? Because especially the
serial-pps patches are interesting as most users connect their
gps/atomic clock/etc. to a serial port for their timekeeping.


Folkert van Heusden

-- 
Multi tail barnamaj mowahib li mora9abat attasjilat wa nataij awamir
al 7asoub. damj, talwin, mora9abat attarchi7 wa ila akhirih.
http://www.vanheusden.com/multitail/
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
