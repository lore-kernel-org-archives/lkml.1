Return-Path: <linux-kernel-owner+w=401wt.eu-S1759922AbYAOX7Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759922AbYAOX7Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 18:59:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756707AbYAOX7F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 18:59:05 -0500
Received: from mail-dub.bigfish.com ([213.199.154.10]:55869 "EHLO
	mail39-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760094AbYAOX7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 18:59:03 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.8;Service: EHS
X-Server-Uuid: 9D002D81-0D89-4A8A-BDDE-D174997CF0D6
From: "Joachim Deguara" <joachim.deguara@amd.com>
Organization: AMD
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: [x86] please setup git for http access
Date: Tue, 15 Jan 2008 15:56:58 -0800
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Message-ID: <200801151556.58881.joachim.deguara@amd.com>
X-OriginalArrivalTime: 15 Jan 2008 23:55:13.0534 (UTC)
 FILETIME=[11E9C1E0:01C857D2]
X-WSS-ID: 6B9398730QK7829377-01-01
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
  I am trying to access the x86 git tree behind a proxy and therefore over the 
http address.  This works for Linus' tree but not for the x86 tree.  Please 
follow these guidelines to enable http access.

http://www.kernel.org/pub/software/scm/git/docs/user-manual.html#exporting-via-http

much appreciated
-Joachim


