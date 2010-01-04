Return-Path: <linux-kernel-owner+w=401wt.eu-S1754042Ab0ADX0i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042Ab0ADX0i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 18:26:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753905Ab0ADX0i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 18:26:38 -0500
Received: from mail.fem.tu-ilmenau.de ([141.24.101.79]:39551 "EHLO
	mail.fem.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753832Ab0ADX0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 18:26:37 -0500
From: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #14938] Unable to handle kernel paging request in radeon_fence_signaled
Date: Tue, 5 Jan 2010 00:26:29 +0100
User-Agent: KMail/1.13.0 (Linux/2.6.33-rc2-00268-g45d28b0; KDE/4.3.85; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "DRI" <dri-devel@lists.sourceforge.net>,
       "Grant Wilson" <grant.wilson@zen.co.uk>
References: <LptzGUUXbTK.A.MSF.ymhOLB@chimera> <NJVdobuNFNK.A.ibG.GnhOLB@chimera>
In-Reply-To: <NJVdobuNFNK.A.ibG.GnhOLB@chimera>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201001050026.31509.johannes.hirte@fem.tu-ilmenau.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag 29 Dezember 2009 16:10:01 schrieb Rafael J. Wysocki:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.32.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14938
> Subject		: Unable to handle kernel paging request in 
radeon_fence_signaled
> Submitter	: Grant Wilson <grant.wilson@zen.co.uk>
> Date		: 2009-12-27 13:40 (3 days old)
> References	: http://marc.info/?l=linux-kernel&m=126192123104047&w=4

This should be the same as http://bugzilla.kernel.org/show_bug.cgi?id=14910.
