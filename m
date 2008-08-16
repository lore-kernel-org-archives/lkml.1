Return-Path: <linux-kernel-owner+w=401wt.eu-S1756431AbYHPUsu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756431AbYHPUsu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 16:48:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757194AbYHPUpg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 16:45:36 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:19157 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756987AbYHPUpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 16:45:34 -0400
Date: Sat, 16 Aug 2008 22:45:26 +0200
From: Jean Delvare <khali@linux-fr.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [Bug #11346] kernel BUG at arch/x86/mm/pat.c:233!
Message-ID: <20080816224526.43145f77@hyperion.delvare>
In-Reply-To: <sNRO-BDDjQL.A.99D.9ZzpIB@albercik>
References: <DLWXHEp37wB.A.duD.yZzpIB@albercik>
	<sNRO-BDDjQL.A.99D.9ZzpIB@albercik>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

On Sat, 16 Aug 2008 21:02:56 +0200 (CEST), Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.26.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11346
> Subject	: kernel BUG at arch/x86/mm/pat.c:233!
> Submitter	: Jean Delvare <khali@linux-fr.org>
> Date		: 2008-08-15 02:10 (2 days old)
> Handled-By	: Andi Kleen <andi@firstfloor.org>
> Patch		: http://bugzilla.kernel.org/attachment.cgi?id=17270&action=view

Andi's patch still needs to be pushed to Linus.

-- 
Jean Delvare
