Return-Path: <linux-kernel-owner+w=401wt.eu-S1762471AbXEKRPe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762471AbXEKRPe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 13:15:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752016AbXEKRP2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 13:15:28 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:45069 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751658AbXEKRP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 13:15:28 -0400
Date: Fri, 11 May 2007 19:15:28 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Linus Torvalds <torvalds@osdl.org>
Cc: linux-kernel@vger.kernel.org
Subject: please pull from the trivial tree
Message-ID: <20070511171528.GF7984@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bunk/trivial.git


This tree contains the following:

David Woodhouse (1):
      further UTF-8 fixes and name correction

Satyam Sharma (1):
      Fix wrong identifier name in Documentation/kref.txt


 CREDITS                      |    4 ++--
 Documentation/kref.txt       |    2 +-
 include/asm-m68k/atarihw.h   |    2 +-
 include/asm-m68k/atariints.h |    2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

