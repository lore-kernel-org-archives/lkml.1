Return-Path: <linux-kernel-owner+w=401wt.eu-S1759567AbXH2U7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759567AbXH2U7S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 16:59:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752812AbXH2U7L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 16:59:11 -0400
Received: from nz-out-0506.google.com ([64.233.162.234]:1393 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752798AbXH2U7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 16:59:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:message-id:mime-version:content-type:content-transfer-encoding:x-mailer:thread-index:content-language:x-cr-hashedpuzzle:x-cr-puzzleid;
        b=aMMXYr+CUIsSzfxRliJD26yI9pM0inSR59Bvbe0YaM37C8GyA0sgaYNj9E9PvOKYBV6X4cTbak5io6pD9nyLCaZVmlRFK1433BcB9OrXQ32mtKdXhooE2eA+yPrdAmRLBfy+zq3ceM0fg5wyM3rLGzPqfxh/CrDuPmlw9Bxs/y0=
From: "Hua Zhong" <hzhong@gmail.com>
To: "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>
Subject: regression of autofs for current git?
Date: Wed, 29 Aug 2007 13:58:58 -0700
Message-ID: <00f401c7ea7f$6db9fc80$492df580$@com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Acfqf2fhopQVT2kOSOCYqFO/cJ34rQ==
Content-Language: en-us
x-cr-hashedpuzzle: ANvO BIDZ CVr9 DCeL DKfU DNIn Dc+H FHg4 FPQQ F7Ss GXpM GYZH HvwW H8Uj H+/i KJK/;1;bABpAG4AdQB4AC0AawBlAHIAbgBlAGwAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA=;Sosha1_v1;7;{FE055F9B-8A1A-40DD-896D-B2A8423C5999};aAB6AGgAbwBuAGcAQABnAG0AYQBpAGwALgBjAG8AbQA=;Wed, 29 Aug 2007 20:58:52 GMT;cgBlAGcAcgBlAHMAcwBpAG8AbgAgAG8AZgAgAGEAdQB0AG8AZgBzACAAZgBvAHIAIABjAHUAcgByAGUAbgB0ACAAZwBpAHQAPwA=
x-cr-puzzleid: {FE055F9B-8A1A-40DD-896D-B2A8423C5999}
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am wondering if this is a known issue, but I just built the current git
and several autofs mounts mysteriously disappeared. Restarting autofs could
fix some, but then lose others. 2.6.22 was fine.

Is there anything I could check other than bisect? (It may take some time
for me to get to it)

Thanks for your help.

Hua

