Return-Path: <linux-kernel-owner+w=401wt.eu-S966036AbXCSRTH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966036AbXCSRTH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 13:19:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966037AbXCSRTH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 13:19:07 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:3572 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966036AbXCSRTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 13:19:06 -0400
Message-ID: <45FEC5F4.8090906@shadowen.org>
Date: Mon, 19 Mar 2007 17:18:44 +0000
From: Andy Whitcroft <apw@shadowen.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
CC: linux-kernel@vger.kernel.org, Alex Tomas <alex@clusterfs.com>
Subject: 2.6.21-rc3-mm2: PG_booked and PG_readahead
X-Enigmail-Version: 0.94.2.0
OpenPGP: url=http://www.shadowen.org/~apw/public-key
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[applogies in advance if this has already been asked]

I note that PG_booked and PG_readahead are both using bit 20 in
2.6.21-rc3-mm2.  Is this intentional or perhaps a miss-merge.  They do
not sound obviously non-overlapping to my mind.

-apw
