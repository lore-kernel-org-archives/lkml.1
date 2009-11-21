Return-Path: <linux-kernel-owner+w=401wt.eu-S1753166AbZKUUpa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166AbZKUUpa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 15:45:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752815AbZKUUp3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 15:45:29 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:49299 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752776AbZKUUp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 15:45:28 -0500
X-Sasl-enc: rQ1rQ21K6H0FfXPm25tI6RhO4xr+TQle2vmeh2MqN+ss 1258836334
Date: Sat, 21 Nov 2009 18:45:32 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #14597] thinkpad-acpi: driver fails to load on old BIOS
 for the A31, T23-T30, X30-X31
Message-ID: <20091121204532.GC10888@khazad-dum.debian.net>
References: <pohDdrcORVG.A.U2B.-6_BLB@chimera>
 <l2_yP_tdgYK.A.OpC.W7_BLB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <l2_yP_tdgYK.A.OpC.W7_BLB@chimera>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Nov 2009, Rafael J. Wysocki wrote:
> The following bug entry is on the current list of known regressions
> from 2.6.31.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14597
> Subject		: thinkpad-acpi: driver fails to load on old BIOS for the A31, T23-T30, X30-X31
> Submitter	: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
> Date		: 2009-11-13 20:45 (9 days old)
> Handled-By	: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
> Patch		: http://bugzilla.kernel.org/attachment.cgi?id=23770

Still outstanding.  Andrew said he was going to send the patch to Linus, so
I hope it will be fixed for 2.6.32-final.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
