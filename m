Return-Path: <linux-kernel-owner+w=401wt.eu-S1755070AbYAHMli@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755070AbYAHMli (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 07:41:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752020AbYAHMla
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 07:41:30 -0500
Received: from az33egw01.freescale.net ([192.88.158.102]:58841 "EHLO
	az33egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450AbYAHMl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 07:41:29 -0500
Subject: [GIT PATCH] Update to Chinese documents
From: Li Yang <leoli@freescale.com>
Reply-To: leoli@freescale.com
To: torvalds@linux-foundation.org, gregkh@suse.de, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-kernel@zh-kernel.org
Content-Type: text/plain
Organization: Freescale Semiconductor
Date: Tue, 08 Jan 2008 20:50:37 +0800
Message-Id: <1199796637.6835.7.camel@Gundam>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Jan 2008 12:40:48.0792 (UTC) FILETIME=[B227E180:01C851F3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from the doc branch at:

git://git.kernel.org/pub/scm/linux/kernel/git/leo/chinese.git doc

to receive the following updates to in-tree Chinese documents
and to add newly translated guideline documents.

I'm not posting the actual patches here, as they are only strange
characters to most of the subscribers here.  They have been reviewed
thoroughly in linux-kernel@zh-kernel.org mail list, which is a
local Linux kernel development mail list with hundreds of active
Chinese Linux developers and enthusiasts.  If you are interested
in the content of these patches, please visit gitweb at:

http://git.kernel.org/?p=linux/kernel/git/leo/chinese.git;a=shortlog;h=doc



Bryan Wu (1):
      Chinese: add translation of volatile-considered-harmful.txt

Dave Young (1):
      Chinese: add translation of oops-tracing.txt

Li Yang (5):
      Chinese: Add the known_regression URI to the HOWTO
      Chinese: rephrase English introduction in HOWTO
      Chinese: Change man-pages maintainer address in HOWOTO
      Chinese: add translation of SubmittingDrivers
      Chinese: add translation of sparse.txt

TripleX Chung (2):
      Chinese: add translation of SubmittingPatches
      Chinese: add translation of stable_kernel_rules.txt

Zhang Le (1):
      Chinese: add translation of Codingstyle

 Documentation/zh_CN/CodingStyle                    |  701 ++++++++++++++++++++
 Documentation/zh_CN/HOWTO                          |   10 +-
 Documentation/zh_CN/SubmittingDrivers              |  168 +++++
 Documentation/zh_CN/SubmittingPatches              |  416 ++++++++++++
 Documentation/zh_CN/oops-tracing.txt               |  212 ++++++
 Documentation/zh_CN/sparse.txt                     |  100 +++
 Documentation/zh_CN/stable_kernel_rules.txt        |   66 ++
 .../zh_CN/volatile-considered-harmful.txt          |  113 ++++
 8 files changed, 1782 insertions(+), 4 deletions(-)


