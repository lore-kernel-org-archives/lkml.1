Return-Path: <linux-kernel-owner+w=401wt.eu-S1756615AbYKVXo0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756615AbYKVXo0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 18:44:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753845AbYKVXoR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 18:44:17 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:57172 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753568AbYKVXoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 18:44:17 -0500
Date: Sun, 23 Nov 2008 00:44:11 +0100
From: Frederik Deweerdt <frederik.deweerdt@xprog.eu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrey Borzenkov <arvidjaar@mail.ru>,
       Frederik Deweerdt <frederik.deweerdt@gmail.com>
Subject: Re: [Bug #12047] ACPI toshiba: only register rfkill if bt is
	enabled
Message-ID: <20081122234411.GD5324@gambetta>
References: <sBqd4qMeLzC.A.mgB.B7HKJB@chimera> <vyitTh0pP2N.A.FBC.U7HKJB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <vyitTh0pP2N.A.FBC.U7HKJB@chimera>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 22, 2008 at 09:28:19PM +0100, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.27.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12047
> Subject		: ACPI toshiba: only register rfkill if bt is enabled
> Submitter	: Andrey Borzenkov <arvidjaar@mail.ru>
> Date		: 2008-10-28 19:10 (26 days old)
> References	: http://marc.info/?l=linux-kernel&m=122522113619025&w=2
> Handled-By	: Frederik Deweerdt <frederik.deweerdt@gmail.com>
> Patch		: http://marc.info/?l=linux-kernel&m=122526843117478&w=2
This went to -mm, I just mailed Andrew about this and should go to
mainline soon.
Regards,
Frederik
