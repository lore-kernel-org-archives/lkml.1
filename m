Return-Path: <linux-kernel-owner+w=401wt.eu-S1759903AbXEKJHH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759903AbXEKJHH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 05:07:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755477AbXEKJGy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 05:06:54 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58477 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754293AbXEKJGx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 05:06:53 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/7] Freezer bugfixes
Date: Fri, 11 May 2007 00:35:31 +0200
User-Agent: KMail/1.9.5
Cc: Gautham R Shenoy <ego@in.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Pavel Machek <pavel@ucw.cz>,
       "Eric W. Biederman" <ebiederm@xmission.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200705110035.32229.rjw@sisk.pl>
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following series of patches is a replacement of the freezer patches
recently dropped by Linus.

Each of the first six patches fixes specific issue related to the freezer, as
explained in the changelogs and in the comments within the patches.  The
last patch is a cleanup.

Please consider them for merging.

Greetings,
Rafael

