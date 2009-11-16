Return-Path: <linux-kernel-owner+w=401wt.eu-S1755002AbZKPWye@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755002AbZKPWye (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 17:54:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754987AbZKPWyc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 17:54:32 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60308 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754981AbZKPWya convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 17:54:30 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Christian Hartmann" <cornogle@googlemail.com>,
       "Jerome Glisse" <glisse@freedesktop.org>
References: <GUZt44bIwCE.A.vLF.pSdALB@chimera>
In-Reply-To: <GUZt44bIwCE.A.vLF.pSdALB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <xXQGFmujPl.A.CeF.wSdALB@chimera>
Subject: [Bug #14628] drm/ksm -> s2disk -> resume -> [drm:r100_ring_test] *ERROR* radeon: ring test failed
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 16 Nov 2009 23:37:49 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.31.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14628
Subject		: drm/ksm -> s2disk -> resume -> [drm:r100_ring_test] *ERROR* radeon: ring test failed
Submitter	: Christian Hartmann <cornogle@googlemail.com>
Date		: 2009-11-06 15:46 (11 days old)
References	: http://marc.info/?l=linux-kernel&m=125752241331067&w=4
Handled-By	: Jerome Glisse <glisse@freedesktop.org>


