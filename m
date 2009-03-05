Return-Path: <linux-kernel-owner+w=401wt.eu-S1755080AbZCECRq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755080AbZCECRq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 21:17:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752642AbZCECRi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 21:17:38 -0500
Received: from gw.goop.org ([64.81.55.164]:40549 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751427AbZCECRh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 21:17:37 -0500
Message-ID: <49AF363E.2060405@goop.org>
Date: Wed, 04 Mar 2009 18:17:34 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: [GIT PULL] fix compiler warnings in page_types.h
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix some gcc 3.2.2 compiler warnings.

    J

The following changes since commit 4c44cf79c1ac92faa2d1268a30c3df2326812902:
  Jeremy Fitzhardinge (1):
        x86: un-__init fill_pud/pmd/pte

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git tip/fixups

Jeremy Fitzhardinge (1):
      x86: clean up old gcc warnings

 arch/x86/include/asm/page_types.h |    6 ------
 arch/x86/include/asm/pat.h        |    5 +++++
 2 files changed, 5 insertions(+), 6 deletions(-)

