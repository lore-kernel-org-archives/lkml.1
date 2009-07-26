Return-Path: <linux-kernel-owner+w=401wt.eu-S1754191AbZGZXNJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191AbZGZXNJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 19:13:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754138AbZGZXNH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 19:13:07 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58386 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754136AbZGZXNF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 19:13:05 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Alan Jenkins" <alan-jenkins@tuffmail.co.uk>,
       "Cijoml Cijomlovic Cijomlov" <cijoml@volny.cz>,
       "Maciej Rutecki" <maciej.rutecki@gmail.com>,
       "Thadeu Lima de Souza Cascardo" <cascardo@holoscopio.com>
References: <Jya1GruKQpD.A.16.2GObKB@chimera>
In-Reply-To: <Jya1GruKQpD.A.16.2GObKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <3zAHs5O6maO.A.JcF.gIObKB@chimera>
Subject: [Bug #13643] Touchpad lost synchronization after resume from suspend to RAM
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 26 Jul 2009 22:23:34 +0200 (CEST)
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
Date		: 2009-06-28 10:42 (29 days old)
References	: http://lkml.org/lkml/2009/6/23/365
		  2.6.30-rc1: touchpad disabled
		  http://lkml.org/lkml/2009/6/25/256
Handled-By	: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Patch		: http://patchwork.kernel.org/patch/34075/


