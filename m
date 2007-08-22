Return-Path: <linux-kernel-owner+w=401wt.eu-S1758281AbXHVIMY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758281AbXHVIMY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 04:12:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752969AbXHVIML
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 04:12:11 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48173 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752168AbXHVIMJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 04:12:09 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: [RFC][PATCH -mm 0/4] Hibernation: Arbitrary boot kernel support on x86_64
Date: Wed, 22 Aug 2007 10:15:15 +0200
User-Agent: KMail/1.9.5
Cc: Andi Kleen <ak@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200708221015.16493.rjw@sisk.pl>
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following patches make it possible to restore a hibernation image with the
help of a kernel different from the image one.

The first patch adds the generic, platform independent code needed for that.
The second patch implements the idea on x86_64 and the two remaining patches
are generalizations.

Details in the changelogs, comments welcome.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth

