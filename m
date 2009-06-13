Return-Path: <linux-kernel-owner+w=401wt.eu-S1753298AbZFMCzr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753298AbZFMCzr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 22:55:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751779AbZFMCzi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 22:55:38 -0400
Received: from vena.lwn.net ([206.168.112.25]:48835 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751775AbZFMCzi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 22:55:38 -0400
Date: Fri, 12 Jun 2009 20:55:38 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PULL] Documentation
Message-ID: <20090612205538.7e74315e@bike.lwn.net>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've got a few things piled up in my documentation tree.  A couple of
additions on how to write better changelogs, a fix or two, and a new
debugfs document.  Guaranteed 100% regression-free.

Patches can be pulled from:

  git://git.lwn.net/linux-2.6.git docs-next

Jonathan Corbet (3):
      Document Reported-by in SubmittingPatches
      docs: Encourage better changelogs in the development process document
      Document the debugfs API

Pavel Machek (1):
      SubmittingPatches: fix typo

Theodore Ts'o (1):
      Documentation: Add "how to write a good patch summary" to SubmittingPatches

 Documentation/SubmittingPatches             |   76 ++++++++++---
 Documentation/development-process/5.Posting |   31 +++++-
 Documentation/filesystems/debugfs.txt       |  158 +++++++++++++++++++++++++++
 3 files changed, 246 insertions(+), 19 deletions(-)
 create mode 100644 Documentation/filesystems/debugfs.txt

jon
