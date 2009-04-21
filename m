Return-Path: <linux-kernel-owner+w=401wt.eu-S1753933AbZDUMpA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933AbZDUMpA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 08:45:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751370AbZDUMov
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 08:44:51 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:54005 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751274AbZDUMou convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 08:44:50 -0400
From: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 21 Apr 2009 18:14:40 +0530
Subject: [PATCH 0/7] OMAP4: Patch series
Thread-Topic: [PATCH 0/7] OMAP4: Patch series
Thread-Index: AcnCfvAoIr940hGsRP+nXewZXw9cLQ==
Message-ID: <EAF47CD23C76F840A9E7FCE10091EFAB02A9A642D1@dbde02.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following is the patch series to enable basic board support for OMAP4430. The patches are generated against mainline version 2.6.30 -rc2. The kernel is validated on the OMAP4430 software simulator platform.

The series contains:
-	[PATCH 1/7][RFC] OMAP4: Create architecture macros and config entries.
-	[PATCH 2/7][RFC] OMAP4: Create board support for OMAP_4430SDP.
-	[PATCH 3/7][RFC] OMAP4: Update common omap platform headers.
-	[PATCH 4/7][RFC] OMAP4: Update common omap platform common sources.
-	[PATCH 5/7][RFC] OMAP4: Update common omap machine specific sources.
-	[PATCH 6/7][RFC] OMAP4: Clock hack since clock management framework not in.
-	[PATCH 7/7][RFC] OMAP4: Enable basic build support.

Regards,
Santosh
