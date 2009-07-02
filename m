Return-Path: <linux-kernel-owner+w=401wt.eu-S1755547AbZGBRpl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547AbZGBRpl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 13:45:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755388AbZGBRpU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 13:45:20 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:64488 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755367AbZGBRpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 13:45:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=rpx1vB3WA/LW2ghTNK+Qd0I19oXDo7ng5WTCs8yk5atMmUCAVsV+4pMZQLc1zzGx2S
         iz/IiTkHpsCiD3XvMk0kFjjEqjKK7+BOPM6sLWdwGBg9UAb/DmLudUmhndTag3aDwjP5
         RUgdnTsLSpeK4o/B+rTLQTqRYre4EemsKvBG4=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: selinux@tycho.nsa.gov
Subject: SELinux-Fix-some-typos.
Date: Thu,  2 Jul 2009 10:46:14 -0700
Message-Id: <1246556775-8942-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.6.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After receiving some feedback about the patches
I had sumbmitted yeasterday, I decided to go
back and resubmit them so they don't create
so much churn(just focus on typos).


 security/selinux/avc.c      |    6 +++---
 security/selinux/hooks.c    |    4 ++--
 security/selinux/netlabel.c |    4 ++--
 3 files changed, 7 insertions(+), 7 deletions(-)


