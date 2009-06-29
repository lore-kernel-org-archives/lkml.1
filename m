Return-Path: <linux-kernel-owner+w=401wt.eu-S1761263AbZF2Aqg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761263AbZF2Aqg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 20:46:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759445AbZF2Aho
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 20:37:44 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38791 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759443AbZF2Ahj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 20:37:39 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
       "Jeremy Kerr" <jk@ozlabs.org>, "Rob Landley" <rob@landley.net>
References: <etTXaRqGgAC.A.SaE.6iASKB@chimera>
In-Reply-To: <etTXaRqGgAC.A.SaE.6iASKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <5Hhc7UkUKEO.A.anE.AjASKB@chimera>
Subject: [Bug #13668] Can't boot 2.6.30 powerpc kernel under qemu.
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 29 Jun 2009 02:31:03 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.29 and 2.6.30.

The following bug entry is on the current list of known regressions
introduced between 2.6.29 and 2.6.30.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13668
Subject		: Can't boot 2.6.30 powerpc kernel under qemu.
Submitter	: Rob Landley <rob@landley.net>
Date		: 2009-06-27 18:08 (2 days old)
References	: http://lkml.org/lkml/2009/6/27/159


