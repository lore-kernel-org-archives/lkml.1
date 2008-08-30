Return-Path: <linux-kernel-owner+w=401wt.eu-S1761297AbYH3Viq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761297AbYH3Viq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 17:38:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758332AbYH3VZq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 17:25:46 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58225 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757602AbYH3VZm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 17:25:42 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>
References: <q6jBvyFdWbL.A.K4C.fhbuIB@albercik>
In-Reply-To: <q6jBvyFdWbL.A.K4C.fhbuIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <N8SeMoDzuxC.A.QkD.4hbuIB@albercik>
Subject: [Bug #11451] /proc/acpi/ibm/wan stopped appearing
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 30 Aug 2008 21:50:26 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.26.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11451
Subject		: /proc/acpi/ibm/wan stopped appearing
Submitter	: Jeremy Fitzhardinge <jeremy@goop.org>
Date		: 2008-08-27 22:11 (4 days old)
References	: http://marc.info/?l=linux-kernel&m=121987514922627&w=4
Handled-By	: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
		  Jeremy Fitzhardinge <jeremy@goop.org>
Patch		: http://marc.info/?l=linux-kernel&m=121989632915800&w=4


