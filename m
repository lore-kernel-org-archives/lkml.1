Return-Path: <linux-kernel-owner+w=401wt.eu-S1753463AbYHJJBt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463AbYHJJBt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 05:01:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751959AbYHJJBl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 05:01:41 -0400
Received: from aun.it.uu.se ([130.238.12.36]:55710 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752430AbYHJJBl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 05:01:41 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18590.44633.509808.376198@harpo.it.uu.se>
Date: Sun, 10 Aug 2008 11:01:13 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Mikael Pettersson" <mikpe@it.uu.se>
Subject: Re: [Bug #11205] x86: 2.6.27-rc1 does not build with gcc-3.2.3 any more
In-Reply-To: <cX_-nNkxKaF.A.13C.ZEjnIB@albercik>
References: <VYYCiQF4qDI.A.BPH.KCjnIB@albercik>
	<cX_-nNkxKaF.A.13C.ZEjnIB@albercik>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 Aug 2008 00:43:51 +0200 (CEST), Rafael J. Wysocki wrote:
>The following bug entry is on the current list of known regressions
>from 2.6.26.  Please verify if it still should be listed and let me know
>(either way).
>
>
>Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D11205
>Subject		: x86: 2.6.27-rc1 does not build with gcc-3.2.3 any more
>Submitter	: Mikael Pettersson <mikpe@it.uu.se>
>Date		: 2008-07-30 11:02 (11 days old)
>References	: http://marc.info/?l=3Dlinux-kernel&m=3D121741584608240&w=3D4
>Handled-By	: Mikael Pettersson <mikpe@it.uu.se>
>Patch		: http://marc.info/?l=3Dlinux-kernel&m=3D121742199419686&w=3D2

No change, the bug is still present, and the patch still applies & works.
