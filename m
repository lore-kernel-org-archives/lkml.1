Return-Path: <linux-kernel-owner+w=401wt.eu-S932301AbZHGXWt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932301AbZHGXWt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 19:22:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932167AbZHGXWs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 19:22:48 -0400
Received: from cantor.suse.de ([195.135.220.2]:49859 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932136AbZHGXWs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 19:22:48 -0400
Date: Sat, 8 Aug 2009 01:22:45 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [Bug #13739] 2.6.30 leaking keys on console switch
In-Reply-To: <7ixSg7D88bK.A.gcF._pgdKB@chimera>
Message-ID: <alpine.LNX.2.00.0908080122130.25797@wotan.suse.de>
References: <upey9ZSfnaF.A.-oE.rpgdKB@chimera> <7ixSg7D88bK.A.gcF._pgdKB@chimera>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2 Aug 2009, Rafael J. Wysocki wrote:

> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.29 and 2.6.30.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.29 and 2.6.30.  Please verify if it still should
> be listed and let me know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13739
> Subject		: 2.6.30 leaking keys on console switch
> Submitter	: Andi Kleen <andi@firstfloor.org>
> Date		: 2009-07-07 8:44 (27 days old)
> References	: http://marc.info/?l=linux-kernel&m=124695628924382&w=4
> Handled-By	: Jiri Kosina <jkosina@suse.cz>

Andi, did the bisection reveal anything?

Thanks,

-- 
Jiri Kosina
SUSE Labs
