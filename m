Return-Path: <linux-kernel-owner+w=401wt.eu-S1755857AbXKRX1u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755857AbXKRX1u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2007 18:27:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753466AbXKRX1n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Nov 2007 18:27:43 -0500
Received: from ishtar.tlinx.org ([64.81.245.74]:44300 "EHLO ishtar.tlinx.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752869AbXKRX1n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2007 18:27:43 -0500
Message-ID: <4740CA6D.9050507@tlinx.org>
Date: Sun, 18 Nov 2007 15:27:41 -0800
From: Linda Walsh <lkml@tlinx.org>
User-Agent: Thunderbird 1.5.0.13 (Windows/20070809)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: ConfigQ? arch=i368; AES (generic v. i586)
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

There are two options for AES cipher algorithms under
the Cryptographic API.  They read:
_ AES Cipher algorithms
_ AES Cipher algorithms (i586)
---

I assume(?) the i586 is for pentiums of some nature -- but is
that any machine pentium(i586) or "newer"(686, P4, Core2, Centrino?).

If both options are selected (mod or compiled in), will the
loading of the AES cipher automatically select the better choice?

Thanks,
Lin

