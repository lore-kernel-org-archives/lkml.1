Return-Path: <linux-kernel-owner+w=401wt.eu-S1757962AbYHBTVv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757962AbYHBTVv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 15:21:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754205AbYHBTVo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 15:21:44 -0400
Received: from fk-out-0910.google.com ([209.85.128.187]:23312 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754102AbYHBTVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 15:21:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=a9A+Mc8uoX1YOIFT50R91+NNfvnJqCH3o6nl1fOaUxVsSkEKfmRIknXPXWUVfqjUg/
         /D86NihG9i1fpV6ualsAxgq2365ta6wfDElMdPwPoge6w1J2NBAdsZ4/6ALhZhrINqE2
         aBid2epv1ekz60kHarH+Yhqcy2Di3gNy8BC4g=
Date: Sat, 2 Aug 2008 21:21:31 +0200
From: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: hpa <hpa@zytor.com>, tglx <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: Coding style fixes
Message-ID: <20080802212131.22e89531@paolo-desktop>
X-Mailer: Sylpheed-Claws 1.0.5 (GTK+ 1.2.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
a new round of coding style fixes.


Paolo Ciarrocchi (5):
  x86: Coding style fixes to arch/x86/boot/compressed/misc.c
  x86: Coding style fixes to arch/x86/kernel/bios_uv.c
  x86: Coding style fixes to arch/x86/lib/strstr_32.c
  x86: Coding style fixes to arch/x86/lib/string_32.c
  x86: Coding style fixes to arch/x86/kernel/paravirt_patch_32.c

 arch/x86/boot/compressed/misc.c     |   10 +++++---
 arch/x86/kernel/bios_uv.c           |   20 ++++++++++++----
 arch/x86/kernel/paravirt_patch_32.c |    2 +-
 arch/x86/lib/string_32.c            |   42 +++++++++++++++++-----------------
 arch/x86/lib/strstr_32.c            |    6 ++--
 5 files changed, 46 insertions(+), 34 deletions(-)

