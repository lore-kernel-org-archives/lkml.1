Return-Path: <linux-kernel-owner+w=401wt.eu-S1756253AbXJIWvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756253AbXJIWvW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 18:51:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753883AbXJIWvO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 18:51:14 -0400
Received: from mga02.intel.com ([134.134.136.20]:11142 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753881AbXJIWvN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 18:51:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,250,1188802800"; 
   d="scan'208";a="243201902"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: TPM driver changes to support multiple locality
Date: Tue, 9 Oct 2007 15:51:11 -0700
Message-ID: <A3258B497F1C1441AD36A2E8B45FD628C7D657@scsmsx412.amr.corp.intel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: TPM driver changes to support multiple locality
Thread-Index: AcgKxuM2ntV1ON6rRG6xzrv121eJtA==
From: "Agarwal, Lomesh" <lomesh.agarwal@intel.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 09 Oct 2007 22:51:12.0622 (UTC) FILETIME=[E41198E0:01C80AC6]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Current TPM driver supports only locality 0. I am planning to add
support so that it can access any locality. Locality parameter will be
passed as parameter. Will this change be acceptable? If yes then I will
modify the driver and send the patch.

Thanks,
Lomesh
