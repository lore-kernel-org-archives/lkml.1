Return-Path: <linux-kernel-owner+w=401wt.eu-S1761384AbZBXAmy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761384AbZBXAmy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 19:42:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758200AbZBXAf0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 19:35:26 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:42880 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758424AbZBXAfX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 19:35:23 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "David Pflug" <dtpflug@gmail.com>
References: <HFSEX4uppGO.A.JSG.2yzoJB@chimera>
In-Reply-To: <HFSEX4uppGO.A.JSG.2yzoJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <LLno3yT_fnC.A.MdG.8yzoJB@chimera>
Subject: [Bug #12757] &gt;2.6.27 dies at cardbus init on laptop
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 23 Feb 2009 23:03:05 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.27 and 2.6.28.

The following bug entry is on the current list of known regressions
introduced between 2.6.27 and 2.6.28.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12757
Subject		: &gt;2.6.27 dies at cardbus init on laptop
Submitter	: David Pflug <dtpflug@gmail.com>
Date		: 2009-02-17 19:28 (7 days old)
References	: http://marc.info/?l=linux-kernel&m=123489904218306&w=4


