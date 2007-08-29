Return-Path: <linux-kernel-owner+w=401wt.eu-S1760006AbXH2Ize@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760006AbXH2Ize (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 04:55:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751762AbXH2Iz0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 04:55:26 -0400
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:57707 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200AbXH2IzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 04:55:25 -0400
Message-ID: <46D532E6.2020708@linux.vnet.ibm.com>
Date: Wed, 29 Aug 2007 14:18:38 +0530
From: Subrata Modak <subrata@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061215)
MIME-Version: 1.0
To: ltp-list@lists.sourceforge.net
CC: kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: LTP-KDUMP Test Plan
Content-Type: multipart/mixed;
 boundary="------------010807080803080503040909"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010807080803080503040909
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Please find attached the Tentative LTP-KDUMP Test case Plan, depicting 
the future work that will be done on LTP-KDUMP.
Regards--
Subrata

--------------010807080803080503040909
Content-Type: text/plain;
 name="TEST_PLAN.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="TEST_PLAN.txt"

Following is the Tentative plan for improving LTP-KDUMP Test-cases:

===========================================================================================================
||S.NO||                 ACTIVITY                                               ||  TENTATIVE-TIME       ||
===========================================================================================================
|| 1  ||      Test and integrate kdump's netdump patch to LTP                   ||   SEP/OCT-2007        ||
|| 2  ||      Modify ltp-kdump to automate all usecases of                      ||   SEP/OCT-2007        ||
||    ||        kdump-network dumping usecases                                  ||                       ||
|| 3  ||      Enhance error handler for kdump test                              ||   OCT/NOV-2007        ||
||    ||        automation script                                               ||                       ||
|| 4  ||      Enhance result analysis module of ltp-kdump                       ||   OCT/NOV-2007        ||
===========================================================================================================


--------------010807080803080503040909--
