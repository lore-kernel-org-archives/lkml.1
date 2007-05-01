Return-Path: <linux-kernel-owner+w=401wt.eu-S1031278AbXEASjh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031278AbXEASjh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 14:39:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031273AbXEASjh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 14:39:37 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:38025 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031278AbXEASjg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 14:39:36 -0400
Message-ID: <46378965.5000802@simon.arlott.org.uk>
Date: Tue, 01 May 2007 19:39:33 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 1.5.0.5 (X11/20060819)
MIME-Version: 1.0
To: trivial@kernel.org
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Duncan Sands <duncan.sands@math.u-psud.fr>
Subject: [PATCH] MAINTAINERS: Add cxacru website/mailing list
X-Enigmail-Version: 0.94.1.2
OpenPGP: id=89C93563
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I've not made any contact with the developers of the sourceforge project, 
but it would be useful for users to able to find the mailing list and the 
website for firmware information even if the driver page is very out of 
date right now.

Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
Cc: Duncan Sands <duncan.sands@math.u-psud.fr>
---
I will email Roman Kagan once I think my cxacru-info utility is ready to 
be released and to point out that the driver's been in the kernel for a 
while and doesn't need to be obtained from cvs.infradead.org (Duncan: are 
you able to make changes to that CVS repository?).

 MAINTAINERS |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index af1c792..b116730 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -984,6 +984,8 @@ S:	Maintained
 CONEXANT ACCESSRUNNER USB DRIVER
 P:	Simon Arlott
 M:	cxacru@fire.lp0.eu
+L:	accessrunner-general@lists.sourceforge.net
+W:	http://accessrunner.sourceforge.net/
 S:	Maintained
 
 COSA/SRP SYNC SERIAL DRIVER
-- 
1.5.0.1

-- 
Simon Arlott
