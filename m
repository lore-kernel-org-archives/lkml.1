Return-Path: <linux-kernel-owner+w=401wt.eu-S932421AbZJEKUB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932421AbZJEKUB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 06:20:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932359AbZJEKUB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 06:20:01 -0400
Received: from mail-yw0-f173.google.com ([209.85.211.173]:51851 "EHLO
	mail-yw0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932348AbZJEKUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 06:20:00 -0400
Message-ID: <4AC9C7F4.20401@monstr.eu>
Date: Mon, 05 Oct 2009 12:18:28 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: torvalds@linux-foundation.org
CC: linux-kernel@vger.kernel.org
Subject: [GIT PULL] arch/microblaze fixes
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull these two changes.

Thanks,
Michal



The following changes since commit 374576a8b6f865022c0fd1ca62396889b23d66dd:
   Linus Torvalds (1):
         Linux 2.6.32-rc3

are available in the git repository at:

   git://git.monstr.eu/linux-2.6-microblaze.git fixes-for-linus

Michal Simek (2):
       microblaze: UMS is used only for MMU kernel
       microblaze: Clear sticky FSR register after saving it to func 
parametr

  arch/microblaze/kernel/entry.S                |    2 ++
  arch/microblaze/kernel/hw_exception_handler.S |    2 +-
  arch/microblaze/kernel/process.c              |    2 ++
  3 files changed, 5 insertions(+), 1 deletions(-)
