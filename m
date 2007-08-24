Return-Path: <linux-kernel-owner+w=401wt.eu-S932938AbXHXKCP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932938AbXHXKCP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 06:02:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763674AbXHXKCA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 06:02:00 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60011 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762401AbXHXKB7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 06:01:59 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -mm 0/2] Hibernation: Arbitrary boot kernel support on x86_64
Date: Fri, 24 Aug 2007 12:06:56 +0200
User-Agent: KMail/1.9.5
Cc: Andi Kleen <ak@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708241206.57178.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following two patches make it possible to restore the memory state from a
hibernation image with the help of a kernel different from the image one.

The first patch adds the generic, platform independent code needed for that.
The second patch implements the idea on x86_64.

Greetings,
Rafael

