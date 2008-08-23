Return-Path: <linux-kernel-owner+w=401wt.eu-S1756250AbYHWTwl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756250AbYHWTwl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 15:52:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755646AbYHWTnF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 15:43:05 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50186 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755347AbYHWTnA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 15:43:00 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Bjorn Helgaas" <bjorn.helgaas@hp.com>, "Frans Pop" <elendil@planet.nl>
References: <mzBsPw3QUOF.A.87F.wZGsIB@albercik>
In-Reply-To: <mzBsPw3QUOF.A.87F.wZGsIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <VSpL6AnBTS.A.RSH.faGsIB@albercik>
Subject: [Bug #11379] char/tpm: tpm_infineon no longer loaded for HP 2510p laptop
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 23 Aug 2008 20:10:22 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.26.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11379
Subject		: char/tpm: tpm_infineon no longer loaded for HP 2510p laptop
Submitter	: Frans Pop <elendil@planet.nl>
Date		: 2008-08-18 13:40 (6 days old)
References	: http://marc.info/?l=linux-kernel&m=121906698213329&w=4
Handled-By	: Bjorn Helgaas <bjorn.helgaas@hp.com>


