Return-Path: <linux-kernel-owner+w=401wt.eu-S1754782AbYINQFh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782AbYINQFh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 12:05:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752896AbYINQF3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 12:05:29 -0400
Received: from main.gmane.org ([80.91.229.2]:54338 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752280AbYINQF2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 12:05:28 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: Turning off camera also kills card reader on EeePC 900
Date: Sun, 14 Sep 2008 16:05:16 +0000 (UTC)
Message-ID: <gajcns$pit$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 87.112.233.179
User-Agent: Pan/0.129 (Benson & Hedges Moscow Gold)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When running Ubuntu from an SD card issuing
echo 0 > /sys/devices/platform/eeepc/camera
as root will cause the camera to be turned off AND the SD card to 
immediately disappear (which is rather fatal when you are using it). It's 
hard to know if this is intended behaviour by the BIOS (given that they 
are both USB devices) or a mistake in the platform driver... 

-- 
Sitsofe | http://sucs.org/~sits/

