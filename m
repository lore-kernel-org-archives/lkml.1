Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754271Ab0BOAAy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 19:00:54 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60672 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754267Ab0BNX7M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 18:59:12 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "=?utf-8?q?Asbj=C3=B8rn=20Sannes?=" <kernelbugzilla@sannes.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "Venkatesh Pallipadi" <venkatesh.pallipadi@intel.com>
References: <Z5cmiqDComP.A.gyF.OiIeLB@chimera>
In-Reply-To: <Z5cmiqDComP.A.gyF.OiIeLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <4un6Gst5rKB.A.rZG.eiIeLB@chimera>
Subject: [Bug #15289] Regression 2.6.32 -> 2.6.33, Kernel needs a helping key to boot :)
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 15 Feb 2010 00:38:36 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.32.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15289
Subject		: Regression 2.6.32 -> 2.6.33, Kernel needs a helping key to boot :)
Submitter	: Asbjørn Sannes <kernelbugzilla@sannes.org>
Date		: 2010-02-12 19:47 (3 days old)
First-Bad-Commit: http://git.kernel.org/git/linus/73472a46b5b28116b145fb5fc05242c1aa8e1461


