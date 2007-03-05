Return-Path: <linux-kernel-owner+w=401wt.eu-S933483AbXCEOg1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933483AbXCEOg1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 09:36:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933484AbXCEOg1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 09:36:27 -0500
Received: from mail-dub.bigfish.com ([213.199.154.10]:25240 "EHLO
	outbound3-dub-R.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933483AbXCEOg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 09:36:26 -0500
X-BigFish: VP
X-Server-Uuid: 519AC16A-9632-469E-B354-112C592D09E8
Date: Mon, 5 Mar 2007 15:36:01 +0100
From: "Joerg Roedel" <joerg.roedel@amd.com>
To: discuss@x86-64.org
cc: "Andi Kleen" <ak@suse.de>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] add reporting of SVM flags to /proc/cpuinfo
Message-ID: <20070305143601.GF30318@amd.com>
MIME-Version: 1.0
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 05 Mar 2007 14:36:02.0119 (UTC)
 FILETIME=[992D1D70:01C75F33]
X-WSS-ID: 69F2F55F2X01975422-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This small patch series introduces the reporting of the SVM revision,
the number of ASIDs and the flags in /proc/cpuinfo on SVM capable AMD
processors.  The patches are for i386 and for x86_64 architectures.

-- 
Joerg Roedel
Operating System Research Center
AMD Saxony LLC & Co. KG


