Return-Path: <linux-kernel-owner+w=401wt.eu-S1757619AbXKZXSo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757619AbXKZXSo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 18:18:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756349AbXKZXSX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 18:18:23 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40846 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753999AbXKZXSX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 18:18:23 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: pm list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 0/6] Suspend and hibernation code cleanups
Date: Tue, 27 Nov 2007 00:25:07 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711270025.08128.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following series of patches contains some suspend and hibernation code
cleanups that I'd like to go into 2.6.25.

The patches are on top of the suspend branch of the linux-acpi-2.6 tree.

Please review.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth

