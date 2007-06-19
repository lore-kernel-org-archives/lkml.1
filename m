Return-Path: <linux-kernel-owner+w=401wt.eu-S1755684AbXFSWrd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755684AbXFSWrd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 18:47:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755152AbXFSWrO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 18:47:14 -0400
Received: from outbound-cpk.frontbridge.com ([207.46.163.16]:53022 "EHLO
	outbound3-cpk-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754273AbXFSWrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 18:47:11 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.22;Service: EHS
X-Server-Uuid: 5FC0E2DF-CD44-48CD-883A-0ED95B391E89
Date: Wed, 20 Jun 2007 00:47:54 +0200
From: "Andreas Herrmann" <andreas.herrmann3@amd.com>
To: "linux-kernel" <linux-kernel@vger.kernel.org>
Subject: [patch 0/12] several fixes from randconfig compiles
Message-ID: <20070619224754.GB5193@alberich.amd.com>
MIME-Version: 1.0
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 19 Jun 2007 22:46:58.0227 (UTC)
 FILETIME=[BE2C0030:01C7B2C3]
X-WSS-ID: 6A66836E23K845461-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a series of minor fixes for problems observed while
doing some randconfig fun on x86_64.

Some problems might have been reported on LKML before. But AFAIK they
are not fixed in current git. Thus I report them again - including
possible fixes.


Regards,

Andreas

-- 
Operating | AMD Saxony Limited Liability Company & Co. KG,
  System  | Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 Research | Register Court Dresden: HRA 4896, General Partner authorized
  Center  | to represent: AMD Saxony LLC (Wilmington, Delaware, US)
  (OSRC)  | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy



