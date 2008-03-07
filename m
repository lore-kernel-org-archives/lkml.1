Return-Path: <linux-kernel-owner+w=401wt.eu-S932818AbYCGVFp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932818AbYCGVFp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 16:05:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932403AbYCGVFM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 16:05:12 -0500
Received: from rn-out-0910.google.com ([64.233.170.191]:7175 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932398AbYCGVFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 16:05:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=AQqr1DqyRz5v9RBDtT8ULreTibjIkFlgV91kJWVfKiWNc4UFY8IuW/B/0rblitrkHagaw4S3rACag7Mpr++r1L5k0JLuLsNbPd/qPYbX2tQHZINkREEdK+GQmwd6LYocWdacXDfYM4KuAdHgaHaK0j+w1aJO30j02G26NY9ZFY4=
Message-ID: <7c86c4470803071305t5d4e581fs66e9fe8288d0392@mail.gmail.com>
Date: Fri, 7 Mar 2008 13:05:07 -0800
From: "stephane eranian" <eranian@googlemail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] perfmon x86 infrastructure definitions (take 2)
Cc: "Andrew Morton" <akpm@linux-foundation.org>, ak@suse.de,
       "Ingo Molnar" <mingo@elte.hu>, tglx@linutronix.de
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Take 2: correct titles and no attachment.

Here is a small set of patches for x86. They are used by perfmon
but they can be applied independently.

patch 1: adds cpu_has_arch_perfmon to cpufeature macros to test for
architectural perfmon  on Intel processors
patch 2: adds AMD Northbridge config MSR definition
patch 3: adds AMD Northbridge PCI Id

Please apply.
Thanks.
