Return-Path: <linux-kernel-owner+w=401wt.eu-S1760771AbZF2Anb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760771AbZF2Anb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 20:43:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759329AbZF2AhG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 20:37:06 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38752 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759336AbZF2AhD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 20:37:03 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Alan Jenkins" <alan-jenkins@tuffmail.co.uk>,
       "Bob Moore" <robert.moore@intel.com>
References: <etTXaRqGgAC.A.SaE.6iASKB@chimera>
In-Reply-To: <etTXaRqGgAC.A.SaE.6iASKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <5Hhc7UkUKEO.A.ukF.UjASKB@chimera>
Subject: [Bug #13620] acpi_enforce_resources broken - conflicting i2c module loaded on some EeePCs
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 29 Jun 2009 02:31:00 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.29 and 2.6.30.

The following bug entry is on the current list of known regressions
introduced between 2.6.29 and 2.6.30.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13620
Subject		: acpi_enforce_resources broken - conflicting i2c module loaded on some EeePCs
Submitter	: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Date		: 2009-06-25 08:31 (4 days old)
References	: <http://lists.alioth.debian.org/pipermail/debian-eeepc-devel/2009-June/002316.html>


