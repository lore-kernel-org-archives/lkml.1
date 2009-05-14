Return-Path: <linux-kernel-owner+w=401wt.eu-S1762632AbZENCBn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762632AbZENCBn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 22:01:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762072AbZENCBc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 22:01:32 -0400
Received: from exprod7og113.obsmtp.com ([64.18.2.179]:42091 "EHLO
	exprod7og113.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762580AbZENCBb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 22:01:31 -0400
From: "Mukker, Atul" <Atul.Mukker@lsi.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "Austria, Winston" <Winston.Austria@lsi.com>,
       "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Date: Wed, 13 May 2009 19:57:46 -0600
Subject: [RFQ] New driver architecture questions
Thread-Topic: [RFQ] New driver architecture questions
Thread-Index: AQHJ1Dfknf0UOX8Ad0KPZ7BskiVDOA==
Message-ID: <6C678488C5CEE74F813A4D1948FD2DC7A95E6D37@cosmail02.lsi.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Kernel experts out there!

 

We (a division of LSI Corp.) are planning to initiate a new driver design for future generation of LSI RAID controllers. The new class of RAID controllers would be supported under various operating systems in addition to Linux.

As part of the revamping exercise, we would like to design the driver in such a fashion that much of the driver source code can be made common across drivers offered for various operating systems.

The obvious benefits being:

1.                   Reduction of feature disparity across various operating systems.

2.                   Increased customer satisfaction in terms of support consistency across all available operating systems.

3.                   More synergy between the driver team members and increased collaboration.

4.                   Decreased overheads in terms of maintenance, fixing issues across the board, defect and change requests tracking etc.

5.                   More channelized test engineering.

etc….

Our concern is, is such a design acceptable to Linux community, with our intention being keeping the model open source.

Insights, feedback would be highly appreciated! 

Best regards,
Atul Mukker
Staff Engineer,
LSI Corp.