Return-Path: <linux-kernel-owner+w=401wt.eu-S1754242AbYDMTom@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242AbYDMTom (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 15:44:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752059AbYDMToe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 15:44:34 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36930 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751999AbYDMTod convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 15:44:33 -0400
Cc: "Soeren Sonnenburg" <kernel@nn7.de>
References: <RR4Oy_oXY2J.A.b0H.A3lAIB@albercik>
In-Reply-To: <RR4Oy_oXY2J.A.b0H.A3lAIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <oq66hWjeF4N.A.WZB.Z6lAIB@albercik>
Subject: [Bug #10117] 2.6.25-current-git sometimes hangs on boot - dual-core Sony Vaio
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 13 Apr 2008 20:56:41 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.24.  Please verify if it still should be listed.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10117
Subject		: 2.6.25-current-git sometimes hangs on boot - dual-core Sony Vaio
Submitter	: Soeren Sonnenburg <kernel@nn7.de>
Date		: 2008-02-23 18:55 (51 days old)
References	: http://lkml.org/lkml/2008/2/23/263
		  http://lkml.org/lkml/2008/4/4/41
		  http://lkml.org/lkml/2008/4/9/69


