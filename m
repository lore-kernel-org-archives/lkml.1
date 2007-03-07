Return-Path: <linux-kernel-owner+w=401wt.eu-S1161143AbXCGBlg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161143AbXCGBlg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 20:41:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161148AbXCGBlf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 20:41:35 -0500
Received: from mail07.syd.optusnet.com.au ([211.29.132.188]:39300 "EHLO
	mail07.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161143AbXCGBlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 20:41:35 -0500
From: Con Kolivas <kernel@kolivas.org>
To: linux-kernel@vger.kernel.org, ck@vds.kolivas.org
Subject: [PATCH] [RSDL-mm 0/6] RSDL cpu scheduler for -mm
Date: Wed, 7 Mar 2007 12:26:42 +1100
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 964
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200703071226.43238.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

What follows is the same patch series that constitutes the RDSL "Rotating 
Staircase DeadLine" cpu scheduler resynced for 2.6.21-rc2-mm2.

A rollup patch that can be applied directly to 2.6.21-rc2-mm2 is here:
http://ck.kolivas.org/patches/staircase-deadline/2.6.21-rc2-mm2-sched-rsdl.patch

and the separate patches that will follow are available here:
http://ck.kolivas.org/patches/staircase-deadline/2.6.21-rc2-mm2/

-- 
-ck
