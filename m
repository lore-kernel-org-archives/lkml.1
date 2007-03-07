Return-Path: <linux-kernel-owner+w=401wt.eu-S1422983AbXCGS2c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422983AbXCGS2c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 13:28:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422978AbXCGS2c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 13:28:32 -0500
Received: from gw.goop.org ([64.81.55.164]:48845 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422972AbXCGS2b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 13:28:31 -0500
Message-ID: <45EF044C.2080307@goop.org>
Date: Wed, 07 Mar 2007 10:28:28 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: tglx@linutronix.de, Dan Hecht <dhecht@vmware.com>,
       Zachary Amsden <zach@vmware.com>, akpm@linux-foundation.org, ak@suse.de,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       LKML <linux-kernel@vger.kernel.org>, john stultz <johnstul@us.ibm.com>
Subject: Re: + stupid-hack-to-make-mainline-build.patch added to -mm tree
References: <45EDD82F.90204@vmware.com> <1173225182.24738.507.camel@localhost.localdomain> <45EE0628.1080108@goop.org> <45EE08E8.2020008@vmware.com> <1173228544.24738.514.camel@localhost.localdomain> <45EE0D10.7070807@vmware.com> <1173230305.24738.529.camel@localhost.localdomain> <45EE1EA3.90803@vmware.com> <1173256666.24738.576.camel@localhost.localdomain> <45EEF966.6060902@goop.org> <20070307175232.GB31371@elte.hu>
In-Reply-To: <20070307175232.GB31371@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> /For you/ it's certainly no big deal, you dont have to fix it up and you 
> dont have to keep it flexible ;)
>   

How flexible does it need to be?  Its a simple time source and event
driver.  How flexible does the pit driver need to be?  It's just a small
leaf node hanging off a large existing piece of kernel infrastructure.

> and really, i'm not expecting miracles, i've never seen any hardware 
> vendor argue /against/ support for their own hardware =B-)
>   

And since when has it been kernel policy to argue against including a
well written, self-contained, vendor-provided driver for a piece of
hardware?

    J
