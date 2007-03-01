Return-Path: <linux-kernel-owner+w=401wt.eu-S965411AbXCARLs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965411AbXCARLs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 12:11:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965413AbXCARLs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 12:11:48 -0500
Received: from sbcsmtp6.sbc.com ([144.160.20.53]:33463 "EHLO
	mlph073.enaf.sfdc.sbc.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965411AbXCARLr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 12:11:47 -0500
X-Greylist: delayed 2768 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Mar 2007 12:11:46 EST
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: 3c905B - Transmit error, Tx status register 82
Date: Thu, 1 Mar 2007 10:25:15 -0600
Message-ID: <0D69EE79F863484FB73D20A95656730D02F9CBA1@ILNORT1MSGUSR18.ITServices.sbc.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: 3c905B - Transmit error, Tx status register 82
Thread-Index: AcdcHjHN+Dhfs4q7SIubh3oFIDdSBQ==
From: "WHITE, JOE \(ASI-AIT\)" <jw2365@att.com>
To: <andrewm@uow.edu.au>, <netdev@oss.sgi.com>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 01 Mar 2007 16:25:16.0452 (UTC) FILETIME=[3235F640:01C75C1E]
X-TM-AS-Product-Ver: SMEX-7.0.0.1433-3.6.1039-15028.000
X-TM-AS-Result: No--9.322300-0.000000-31
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This server I inherited is a SUSE Linux box.  

Here is the eth0 device info: eth0      device: 3Com Corporation 3c905B
100BaseTX [Cyclone] (rev 24)


There is this reoccurring issue I am seeing in the /var/log/messages:

Mar  1 09:44:04 thor kernel: eth0: Transmit error, Tx status register
82.
Mar  1 09:44:04 thor kernel: Probably a duplex mismatch.  See
Documentation/networking/vortex.txt

Any ideas on how I can fix this issue, I have been all over google and
have not found a solution.


Joe White
AT&T Midwest
Manager Web Development
Phone: 847-248-7800
Pager: 312-689-3100

