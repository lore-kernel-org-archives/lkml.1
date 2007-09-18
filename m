Return-Path: <linux-kernel-owner+w=401wt.eu-S1758720AbXIRVjl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758720AbXIRVjl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 17:39:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753547AbXIRVjc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 17:39:32 -0400
Received: from mail0.lsil.com ([147.145.40.20]:61400 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752239AbXIRVja convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 17:39:30 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: kdump detection in SCSI drivers
Date: Tue, 18 Sep 2007 15:39:28 -0600
Message-ID: <9738BCBE884FDB42801FAD8A7769C26501B2C44C@NAMAIL1.ad.lsil.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: kdump detection in SCSI drivers
Thread-Index: Acf6PGP+AetV9gwHTem8lFTwLhfUPw==
From: "Mukker, Atul" <Atul.Mukker@lsi.com>
To: <Linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 18 Sep 2007 21:39:29.0178 (UTC) FILETIME=[645767A0:01C7FA3C]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Is there a standard way for drivers (RAID) to detect if the current
kernel is running in kdump mode? We would like to adjust driver behavior
dynamically when kdump is active by scaling down resources.

Thanks
-Atul Mukker
LSI Corp.
