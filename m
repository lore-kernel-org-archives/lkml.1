Return-Path: <linux-kernel-owner+w=401wt.eu-S1751845AbXCQW0L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751845AbXCQW0L (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 18:26:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752072AbXCQW0L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 18:26:11 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41615 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751845AbXCQW0K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 18:26:10 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -mm 0/2] swsusp: Use GFP_KERNEL for creating basic data structures
Date: Sat, 17 Mar 2007 23:22:32 +0100
User-Agent: KMail/1.9.5
Cc: Pavel Machek <pavel@ucw.cz>, LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703172322.33079.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The first of the following two patches fixes a bug in the swsusp's userland
interface and the second one makes swsusp use GFP_KERNEL allocations for
creating its basic memory bitmaps.

Greetings,
Rafael

