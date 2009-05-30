Return-Path: <linux-kernel-owner+w=401wt.eu-S1762780AbZE3W7G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762780AbZE3W7G (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 18:59:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758426AbZE3Wyl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 18:54:41 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46814 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760049AbZE3Wyh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 18:54:37 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Arjan van de Ven" <arjan@linux.intel.com>,
       "Benny Halevy" <bhalevy@panasas.com>, "Jeff Garzik" <jeff@garzik.org>,
       "Matthew Wilcox" <matthew@wil.cx>
References: <THxQaUP0K2D.A.QkF.UVbIKB@chimera>
In-Reply-To: <THxQaUP0K2D.A.QkF.UVbIKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <PkPeJtNB3KO.A.vZG.vVbIKB@chimera>
Subject: [Bug #13175] initrd fails to find /dev/sda* (sata_nv)
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 30 May 2009 21:55:37 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.28 and 2.6.29.

The following bug entry is on the current list of known regressions
introduced between 2.6.28 and 2.6.29.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13175
Subject		: initrd fails to find /dev/sda* (sata_nv)
Submitter	: Benny Halevy <bhalevy@panasas.com>
Date		: 2009-04-21 7:03 (40 days old)
References	: http://marc.info/?l=linux-kernel&m=124029746431777&w=4


