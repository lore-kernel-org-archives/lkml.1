Return-Path: <linux-kernel-owner+w=401wt.eu-S1757253AbYIDII0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757253AbYIDII0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 04:08:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756921AbYIDIGc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 04:06:32 -0400
Received: from styx.suse.cz ([82.119.242.94]:33291 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757111AbYIDIGa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 04:06:30 -0400
Date: Thu, 4 Sep 2008 10:06:28 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Jiri Slaby <jirislaby@gmail.com>, Randy Dunlap <randy.dunlap@oracle.com>
cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH] hid: fix gyration build error
In-Reply-To: <48BF85C7.5050401@gmail.com>
Message-ID: <alpine.LNX.1.10.0809041005440.23448@jikos.suse.cz>
References: <20080903191619.6b6b230e.sfr@canb.auug.org.au> <20080903193218.d79e0f1a.randy.dunlap@oracle.com> <48BF85C7.5050401@gmail.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Sep 2008, Jiri Slaby wrote:

> > From: Randy Dunlap <randy.dunlap@oracle.com>
> > Fix config symbol name in ifdef to fix build error:
> > ERROR: "hid_compat_gyration" [drivers/hid/hid-dummy.ko] undefined!
> > Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> > cc: Jiri Kosina <jkosina@suse.cz>
> Acked-by: Jiri Slaby <jirislaby@gmail.com>

Applied, thanks for catching it.

-- 
Jiri Kosina
SUSE Labs
