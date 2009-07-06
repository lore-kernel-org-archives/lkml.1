Return-Path: <linux-kernel-owner+w=401wt.eu-S1755409AbZGFX5P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409AbZGFX5P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 19:57:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754043AbZGFX4Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 19:56:25 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57838 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754286AbZGFX4T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 19:56:19 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Alan Jenkins" <alan-jenkins@tuffmail.co.uk>,
       "Cijoml Cijomlovic Cijomlov" <cijoml@volny.cz>,
       "Maciej Rutecki" <maciej.rutecki@gmail.com>,
       "Thadeu Lima de Souza Cascardo" <cascardo@holoscopio.com>
References: <35kKlbXMqWN.A.RXD.D0oUKB@chimera>
In-Reply-To: <35kKlbXMqWN.A.RXD.D0oUKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <dWkuWjWDsSB.A.pqF.x0oUKB@chimera>
Subject: [Bug #13643] Touchpad lost synchronization after resume from suspend to RAM
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue,  7 Jul 2009 01:49:28 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.30.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13643
Subject		: Touchpad lost synchronization after resume from suspend to RAM
Submitter	: Cijoml Cijomlovic Cijomlov <cijoml@volny.cz>
Date		: 2009-06-28 10:42 (9 days old)
References	: http://lkml.org/lkml/2009/6/23/365
		  2.6.30-rc1: touchpad disabled
		  http://lkml.org/lkml/2009/6/25/256
Handled-By	: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Patch		: http://patchwork.kernel.org/patch/34075/


