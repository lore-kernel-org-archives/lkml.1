Return-Path: <linux-kernel-owner+w=401wt.eu-S1752641AbYAMNpo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641AbYAMNpo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 08:45:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751459AbYAMNpe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 08:45:34 -0500
Received: from ikar.perftech.si ([195.246.0.20]:4698 "EHLO ikar.perftech.si"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751457AbYAMNpd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 08:45:33 -0500
X-Greylist: delayed 986 seconds by postgrey-1.27 at vger.kernel.org; Sun, 13 Jan 2008 08:45:33 EST
X-ASG-Debug-ID: 1200230941-043f00020000-xx1T2L
X-Barracuda-URL: http://10.12.0.14:5000/cgi-bin/mark.cgi
X-Spam-Processed: dedal.perftech.si, Sun, 13 Jan 2008 14:29:00 +0100
	(not processed: spam filter heuristic analysis disabled)
X-Authenticated-Sender: xerces8@butn.net
X-Return-Path: xerces8@butn.net
X-Envelope-From: xerces8@butn.net
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Date: Sun, 13 Jan 2008 14:28:58 +0100
From: "xerces8" <xerces8@butn.net>
To: linux-kernel@vger.kernel.org
X-ASG-Orig-Subj: isofs maintainer and write support
Subject: isofs maintainer and write support
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-ID: <WorldClient-F200801131428.AA28580079@butn.net>
X-Mailer: WorldClient 9.6.4rc2
X-MDAV-Processed: dedal.perftech.si, Sun, 13 Jan 2008 14:29:01 +0100
X-Barracuda-Connect: UNKNOWN[10.12.0.44]
X-Barracuda-Start-Time: 1200230941
X-Barracuda-Virus-Scanned: by OUTBOUND - ikar.perftech.si at perftech.si
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=7.0 tests=UNPARSEABLE_RELAY
X-Barracuda-Spam-Report: Code version 3.1, rules version 3.1.39418
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.00 UNPARSEABLE_RELAY      Informational: message has unparseable relay lines
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I write here as the MAINTAINERS file has no entry about the isofs.

The question is : Is there any plan/way/idea to have read/write support
for isofs ?

I know of user space tools that can perform any operation (like
create/read/write/rename/delete file/directory) but that is nowhere
as convenient as a real filesystem.

Use case: Editing a iso9660 filesystem on a DVD+RW. With a r/w isofs most
changes would take a few seconds, while without, the entire 4.5 gigabytes
must be copied to HD, edited and then remastered back to the DVD medium.
(Why I don't use another FS ? Because I use the DVD to store music for
my car cd/dvd player and it understands only iso9660.)
(neither does it know vorbis. Or aac+ :-( )

Regards,
David Balažic


