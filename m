Return-Path: <linux-kernel-owner+w=401wt.eu-S1755901AbYCMPhG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755901AbYCMPhG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 11:37:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753218AbYCMPgz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 11:36:55 -0400
Received: from mailgw4.ericsson.se ([193.180.251.62]:43550 "EHLO
	mailgw4.ericsson.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436AbYCMPgz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 11:36:55 -0400
X-Greylist: delayed 1572 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Mar 2008 11:36:54 EDT
X-AuditID: c1b4fb3e-ac995bb000004ec0-10-47d943c12c8f
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: checkpatch.pl and statics
Date: Thu, 13 Mar 2008 16:09:51 +0100
Message-ID: <6006DAC0B81F85439BC960F36F929CDFB5F5EE@eseldmw101.eemea.ericsson.se>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: checkpatch.pl and statics
Thread-Index: AciFHElhM4OrDrohQGO8HT5gSO+4TQ==
From: "Andreas Westin XX" <andreas.xx.westin@ericsson.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 13 Mar 2008 15:09:52.0559 (UTC) FILETIME=[49E82BF0:01C8851C]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello,

I ran checkpatch.pl on a piece of code I wrote and besides all the other
warnings/errors it complained about a static pointer being initialised
to NULL/0. I fixed it but I'm curious as to why this is not permitted ?

Please cc me as I'm not on the list.

/Andreas
