Return-Path: <linux-kernel-owner+w=401wt.eu-S1754420Ab0AJWmK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754420Ab0AJWmK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 17:42:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754395Ab0AJWmG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 17:42:06 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:57952 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754331Ab0AJWlf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 17:41:35 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Hugh Dickins" <hugh.dickins@tiscali.co.uk>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>
References: <wnS54-l8PVO.A.TlF.oMlSLB@chimera>
In-Reply-To: <wnS54-l8PVO.A.TlF.oMlSLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <omZ8aBZReyD.A.zcG.3MlSLB@chimera>
Subject: [Bug #15033] drm: gem_object_free without struct_mutex
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 10 Jan 2010 23:32:58 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.32.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15033
Subject		: drm: gem_object_free without struct_mutex
Submitter	: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Date		: 2009-12-30 19:45 (12 days old)
References	: http://marc.info/?l=linux-kernel&m=126220236201529&w=4
Handled-By	: Jesse Barnes <jbarnes@virtuousgeek.org>


