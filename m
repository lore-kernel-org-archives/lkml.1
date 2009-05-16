Return-Path: <linux-kernel-owner+w=401wt.eu-S1758454AbZEPWRk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758454AbZEPWRk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 18:17:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757672AbZEPWOn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 18:14:43 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43865 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757522AbZEPWOk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 18:14:40 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Alex Bennee" <kernel-hacker@bennee.com>
References: <_AjETDMbIoL.A.DcH.RYzDKB@chimera>
In-Reply-To: <_AjETDMbIoL.A.DcH.RYzDKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <385Pu-agh7M.A.TkB.LZzDKB@chimera>
Subject: [Bug #13171] 2.6.30-rc2 + xorg-intel-2.7.0 + DRM_I915_KMS = corruption
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 16 May 2009 21:20:40 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.29.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13171
Subject		: 2.6.30-rc2 + xorg-intel-2.7.0 + DRM_I915_KMS = corruption
Submitter	: Alex Bennee <kernel-hacker@bennee.com>
Date		: 2009-04-19 6:27 (28 days old)
References	: http://marc.info/?l=linux-kernel&m=124022460014812&w=4


