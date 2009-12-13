Return-Path: <linux-kernel-owner+w=401wt.eu-S1754493AbZLMWJ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493AbZLMWJ1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 17:09:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754494AbZLMWJ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 17:09:26 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:42306 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754491AbZLMWJZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 17:09:25 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: pm list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 0/2/ PM: Core device suspend/resume code cleanups
Date: Sun, 13 Dec 2009 23:06:57 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-rjw; KDE/4.3.3; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200912132306.57741.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following two patches clean up the core suspend/resume code a bit.
I hope no one will have any objections to them, as I'd like to include them in
my next pull request.

Please review.

Rafael

