Return-Path: <linux-kernel-owner+w=401wt.eu-S1758903AbYDMTu6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758903AbYDMTu6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 15:50:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755171AbYDMTo6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 15:44:58 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36970 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755168AbYDMToq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 15:44:46 -0400
Cc: "Adrian Bunk" <bunk@kernel.org>
References: <RR4Oy_oXY2J.A.b0H.A3lAIB@albercik>
In-Reply-To: <RR4Oy_oXY2J.A.b0H.A3lAIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <oq66hWjeF4N.A._3H.E3lAIB@albercik>
Subject: [Bug #10450] sh64: add missing #include &lt;asm/fpu.h&gt;'s
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 13 Apr 2008 20:56:42 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.24.  Please verify if it still should be listed.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10450
Subject		: sh64: add missing #include &lt;asm/fpu.h&gt;'s
Submitter	: Adrian Bunk <bunk@kernel.org>
Date		: 2008-04-13 11:23 (1 days old)
References	: http://lkml.org/lkml/2008/4/13/171
Handled-By	: Adrian Bunk <bunk@kernel.org>
Patch		: http://lkml.org/lkml/2008/4/13/171


