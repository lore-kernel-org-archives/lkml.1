Return-Path: <linux-kernel-owner+w=401wt.eu-S1760157AbYCGGZA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760157AbYCGGZA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 01:25:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755441AbYCGGYv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 01:24:51 -0500
Received: from wf-out-1314.google.com ([209.85.200.169]:12677 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755305AbYCGGYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 01:24:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=vqxZZ/yVoUSQ4m+qHjXSKnjNS/rascdqgR0DLdUgo5XTq0MPwb6qXuB9ZFod/mRwux3Hygenv61t7V0TWfMGHbcwClxq2ysmqWHD0ozqar5wDCad4xDtWdh2TYywt+wbaLgWN6YXMc6erX/Qdh47fiP87/8LU+itoiqsEMEidNk=
Message-ID: <7c86c4470803062224n6deacb03qf933b26311c573b3@mail.gmail.com>
Date: Thu, 6 Mar 2008 22:24:48 -0800
From: "stephane eranian" <eranian@googlemail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] perfmon x86 infrastructure definitions
Cc: akpm@linux-foundation.org, ak@suse.de,
       "Robert Richter" <robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Here is a small set of patches for x86. They are used by perfmon
but they can be applied independently.

patch 1: adds cpu_has_arch_perfmon to cpufeature macros to test for
architectural perfmon  on Intel processors
patch 2: adds AMD Northbridge config MSR definition
patch 3: adds AMD Northbridge PCI Id

Please apply.
Thanks.
