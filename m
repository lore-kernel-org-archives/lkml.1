Return-Path: <linux-kernel-owner+w=401wt.eu-S1758752AbZFKNBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758752AbZFKNBR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 09:01:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752367AbZFKNBA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 09:01:00 -0400
Received: from [212.98.175.89] ([212.98.175.89]:59244 "EHLO localdomain.by"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751128AbZFKNA7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 09:00:59 -0400
Date: Thu, 11 Jun 2009 16:02:09 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #13313] vm86old oops
Message-ID: <20090611130209.GA3458@localdomain.by>
References: <bCxQpon4SCJ.A.RrF.yY7KKB@chimera> <D9VoutSOyXP.A.y8H.Ma7KKB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D9VoutSOyXP.A.y8H.Ma7KKB@chimera>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (06/07/09 11:52), Rafael J. Wysocki wrote:
>
> The following bug entry is on the current list of known regressions
> from 2.6.29.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13313
> Subject		: vm86old oops
> Submitter	: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
> Date		: 2009-05-14 21:53 (25 days old)
> 

Hello Rafael.

commit 3aa6b186f86c5d06d6d92d14311ffed51f091f40
Author: Lubomir Rintel <lkundrak@v3.sk>
Date:   Sun Jun 7 16:23:48 2009 +0200

x86: Fix non-lazy GS handling in sys_vm86()


        Sergey
