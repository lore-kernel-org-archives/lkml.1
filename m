Return-Path: <linux-kernel-owner+w=401wt.eu-S1756014AbYF2TcF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756014AbYF2TcF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 15:32:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755761AbYF2TbS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 15:31:18 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45659 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755016AbYF2TbS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 15:31:18 -0400
Cc: "Alexey Starikovskiy" <astarikovskiy@suse.de>,
       "Justin Mattock" <justinmattock@gmail.com>
References: <q5WW6DLC10O.A.dxC.R69ZIB@albercik>
In-Reply-To: <q5WW6DLC10O.A.dxC.R69ZIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <X8mbwW6K81I.A.RPG.j99ZIB@albercik>
Subject: [Bug #10724] ACPI: EC: GPE storm detected, disabling EC GPE
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 29 Jun 2008 20:18:42 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.25.  Please verify if it still should be listed.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10724
Subject		: ACPI: EC: GPE storm detected, disabling EC GPE
Submitter	: Justin Mattock <justinmattock@gmail.com>
Date		: 2008-05-16 6:17 (45 days old)
References	: http://marc.info/?l=linux-kernel&m=121091875711824&w=4
		  http://lkml.org/lkml/2008/5/18/168
		  http://lkml.org/lkml/2008/5/25/195
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=16364&action=view
		  http://bugzilla.kernel.org/attachment.cgi?id=16365&action=view


