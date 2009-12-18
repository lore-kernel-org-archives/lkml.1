Return-Path: <linux-kernel-owner+w=401wt.eu-S1755621AbZLRTmO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755621AbZLRTmO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 14:42:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755594AbZLRTmB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 14:42:01 -0500
Received: from smtp-04.oit.duke.edu ([152.3.174.85]:60918 "EHLO smtp.duke.edu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755569AbZLRTl6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 14:41:58 -0500
X-Greylist: delayed 558 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Dec 2009 14:41:58 EST
MIME-Version: 1.0
X-Mailer: AtMail PHP 5.61
Message-ID: <50664.1261164757@duke.edu>
To: <linux-kernel@vger.kernel.org>
Reply-To: rb6@duke.edu
Content-Type: text/plain; charset="utf-8"
X-Origin: 71.111.201.152
X-Atmail-Account: rb6@duke.edu
Date: Fri, 18 Dec 2009 14:32:37 -0500
Subject: intel_bufmgr_gem.c:825: Error setting to CPU domain 626: Input/output error
From: Rann Bar-On <rb6@duke.edu>
Content-Transfer-Encoding: 8BIT
X-PMX-Version: 5.4.2.338381, Antispam-Engine: 2.6.0.325393, Antispam-Data: 2009.12.18.192418
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Plz cc me, as I am not on the list.

With 2.6.32 or newer on Intel (in this case GM965, but also confirmed with
others), X does not start properly.  Errors similar to the one in the
subject line occur in Xorg.0.log.  Reports at:

http://bugs.gentoo.org/show_bug.cgi?id=295777

and

http://groups.google.com/group/linux.debian.kernel/browse_thread/thread/543d6ac539cb0efa/124a9a6a92d16cc2?lnk=raot

There is some suspicion this is caused by framebuffer compression and more
speculation that this only appears with 4GB of ram.

Plz help! (and plz cc me)

Thanks,
Rann



