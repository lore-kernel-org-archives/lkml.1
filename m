Return-Path: <linux-kernel-owner+w=401wt.eu-S1758917AbZAHKOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758917AbZAHKOS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 05:14:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751676AbZAHKN6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 05:13:58 -0500
Received: from casper.infradead.org ([85.118.1.10]:44884 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752802AbZAHKN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 05:13:57 -0500
Subject: [PATCH -tip 0/2] x86: rename intel_mp_floating and its all fields
From: Jaswinder Singh Rajput <jaswinder@infradead.org>
To: Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andi Kleen <andi@firstfloor.org>, astarikovskiy@suse.de,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 08 Jan 2009 15:41:28 +0530
Message-Id: <1231409488.7119.2.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 91506140696f1bc1a48258b17f2a768aa2090af5:
  Ingo Molnar (1):
        Merge branch 'linus'

Jaswinder Singh Rajput (2):
      x86: rename intel_mp_floating to mpf_intel
      x86: rename all fields of mpf_intel mpf_X to X

 arch/x86/include/asm/mpspec_def.h |   23 +++++++------
 arch/x86/kernel/mpparse.c         |   62 ++++++++++++++++++------------------
 2 files changed, 43 insertions(+), 42 deletions(-)


