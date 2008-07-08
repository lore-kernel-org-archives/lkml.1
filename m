Return-Path: <linux-kernel-owner+w=401wt.eu-S932537AbYGHXev@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932537AbYGHXev (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 19:34:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932093AbYGHXWZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 19:22:25 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:41472 "EHLO pardus.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759359AbYGHXWX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 19:22:23 -0400
From: "=?iso-8859-9?q?S=2E=C7a=F0lar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Subject: Re: Intel 8100 Error inserting acpi_cpufreq
Date: Wed, 9 Jul 2008 02:22:12 +0300
User-Agent: KMail/1.9.9
Cc: Dave Jones <davej@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
References: <200806242025.04252.caglar@pardus.org.tr> <7E82351C108FA840AB1866AC776AEC4606577D9A@orsmsx505.amr.corp.intel.com>
In-Reply-To: <7E82351C108FA840AB1866AC776AEC4606577D9A@orsmsx505.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-9"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200807090222.14259.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi;

26 Haz 2008 Per tarihinde, Pallipadi, Venkatesh þunlarý yazmýþtý: 
> 
> Most likely BIOS is not exporting relevant ACPI tables for the driver to detect the frequencies and such.
> Latest BIOS and enabling Speedstep in BIOS options will be the things to check.

According to reporter latest BIOS update solved that issue...

> Thanks,
> Venki

Cheers
-- 
S.Çaðlar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in house!
