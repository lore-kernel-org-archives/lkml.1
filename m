Return-Path: <linux-kernel-owner+w=401wt.eu-S1761938AbYBSLOA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761938AbYBSLOA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 06:14:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758293AbYBSLNd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 06:13:33 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:55041 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757289AbYBSLNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 06:13:30 -0500
Date: Tue, 19 Feb 2008 03:19:28 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH 0/8] AMD opteron mm config numa etc
To: Ingo Molnar <mingo@elte.hu>
Cc: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-id: <200802190319.28699.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

please check some amd opteron related mmconf and numa patches

could make up for system that system have acpi problem
or still can mmconf and numa when acpi=off

YH
