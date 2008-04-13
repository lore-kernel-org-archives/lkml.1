Return-Path: <linux-kernel-owner+w=401wt.eu-S1759294AbYDMTvh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759294AbYDMTvh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 15:51:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755831AbYDMTo7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 15:44:59 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36976 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755043AbYDMTop convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 15:44:45 -0400
Cc: "Plamen Petrov" <pvp-lsts@fs.ru.acad.bg>
References: <RR4Oy_oXY2J.A.b0H.A3lAIB@albercik>
In-Reply-To: <RR4Oy_oXY2J.A.b0H.A3lAIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <oq66hWjeF4N.A.SU.W3lAIB@albercik>
Subject: [Bug #10412] BUG: scheduling while atomic: kmail/32546/0x00000003
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 13 Apr 2008 20:56:42 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.24.  Please verify if it still should be listed.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10412
Subject		: BUG: scheduling while atomic: kmail/32546/0x00000003
Submitter	: Plamen Petrov <pvp-lsts@fs.ru.acad.bg>
Date		: 2008-04-07 02:33 (7 days old)


