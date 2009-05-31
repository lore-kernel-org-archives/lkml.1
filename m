Return-Path: <linux-kernel-owner+w=401wt.eu-S1754052AbZEaU3u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052AbZEaU3u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 May 2009 16:29:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753304AbZEaU3m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 May 2009 16:29:42 -0400
Received: from dallas.jonmasters.org ([72.29.103.172]:43594 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753249AbZEaU3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 May 2009 16:29:41 -0400
Message-Id: <20090531163117.502167374@jonmasters.org>
User-Agent: quilt/0.47-1
Date: Sun, 31 May 2009 12:31:17 -0400
From: Jon Masters <jonathan@jonmasters.org>
To: linux-kernel@vger.kernel.org
Cc: jonathan@jonmasters.org, jcm@redhat.com, tglx@linutronix.de, mingo@elte.hu,
       rostedt@goodmis.org
Subject: [RFC PATCH 0/1] SMI Detector (v2)
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jcm@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,

Please find attached my re-write of the SMI detector. This version uses
Steven Rostedt's ring_buffer, fixes various locking and style issues, and
passes checkpatch properly this time around :)

Comments welcome!

Jon.
