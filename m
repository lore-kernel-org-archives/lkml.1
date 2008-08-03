Return-Path: <linux-kernel-owner+w=401wt.eu-S1756978AbYHCSZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756978AbYHCSZ2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 14:25:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752249AbYHCSZR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 14:25:17 -0400
Received: from aun.it.uu.se ([130.238.12.36]:56399 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751263AbYHCSZP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 14:25:15 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18581.63477.482538.137844@harpo.it.uu.se>
Date: Sun, 3 Aug 2008 20:24:53 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Mikael Pettersson" <mikpe@it.uu.se>
Subject: Re: [Bug #11205] x86: 2.6.27-rc1 does not build with gcc-3.2.3 any more
In-Reply-To: <5ZeQ4vXWqRC.A.PFE.SNLlIB@albercik>
References: <cbItfVMShGI.A.olC.UMLlIB@albercik>
	<5ZeQ4vXWqRC.A.PFE.SNLlIB@albercik>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat,  2 Aug 2008 20:04:20 +0200 (CEST), Rafael J. Wysocki <rjw@sisk.pl> wrote:
>This message has been generated automatically as a part of a report
>of recent regressions.
>
>The following bug entry is on the current list of known regressions
>from 2.6.26.  Please verify if it still should be listed
>and let me know (either way).
>
>
>Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D11205
>Subject		: x86: 2.6.27-rc1 does not build with gcc-3.2.3 any more
>Submitter	: Mikael Pettersson <mikpe@it.uu.se>
>Date		: 2008-07-30 11:02 (4 days old)
>References	: http://marc.info/?l=3Dlinux-kernel&m=3D121741584608240&w=3D4

The bug is still present.
Patch here <http://marc.info/?l=linux-kernel&m=121742199419686&w=2>.
