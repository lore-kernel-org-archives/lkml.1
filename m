Return-Path: <linux-kernel-owner+w=401wt.eu-S1754202AbZGZXSL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202AbZGZXSL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 19:18:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754248AbZGZXSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 19:18:09 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58436 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754204AbZGZXSF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 19:18:05 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Dave Airlie" <airlied@gmail.com>, "Frans Pop" <elendil@planet.nl>
References: <Jya1GruKQpD.A.16.2GObKB@chimera>
In-Reply-To: <Jya1GruKQpD.A.16.2GObKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <3zAHs5O6maO.A.dqE.NIObKB@chimera>
Subject: [Bug #13667] drm: display arifacts when X.Org is stopped
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 26 Jul 2009 22:28:20 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.30.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13667
Subject		: drm: display arifacts when X.Org is stopped
Submitter	: Frans Pop <elendil@planet.nl>
Date		: 2009-06-27 18:52 (30 days old)
References	: http://lkml.org/lkml/2009/6/27/105
		  http://lkml.org/lkml/2009/7/8/30


