Return-Path: <linux-kernel-owner+w=401wt.eu-S1756211AbZJZTkf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756211AbZJZTkf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 15:40:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756197AbZJZTke
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 15:40:34 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59863 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756182AbZJZTkc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 15:40:32 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "James Bottomley" <James.Bottomley@suse.de>,
       "Michael Ellerman" <michael@ellerman.id.au>,
       "Tetsuo Handa" <penguin-kernel@i-love.sakura.ne.jp>
References: <G2WU8XrUVpF.A.lxF.Ref5KB@chimera>
In-Reply-To: <G2WU8XrUVpF.A.lxF.Ref5KB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <vX3ILojF2dJ.A.XGH.Eff5KB@chimera>
Subject: [Bug #14258] Memory leak in SCSI initialization
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 26 Oct 2009 20:31:53 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.30 and 2.6.31.

The following bug entry is on the current list of known regressions
introduced between 2.6.30 and 2.6.31.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14258
Subject		: Memory leak in SCSI initialization
Submitter	: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Date		: 2009-09-22 4:18 (35 days old)
References	: http://marc.info/?l=linux-kernel&m=125359311312243&w=4
Handled-By	: Michael Ellerman <michael@ellerman.id.au>
		  James Bottomley <James.Bottomley@suse.de>
Patch		: http://patchwork.kernel.org/patch/51412/


