Return-Path: <linux-kernel-owner+w=401wt.eu-S1756140AbZIPMBL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756140AbZIPMBL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 08:01:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756049AbZIPMBJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 08:01:09 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:34597 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756041AbZIPMBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 08:01:08 -0400
Date: Wed, 16 Sep 2009 14:01:10 +0200
From: Kurt Roeckx <kurt@roeckx.be>
To: David Rientjes <rientjes@google.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Dave Jones <davej@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Kernel Testers <kernel-testers@vger.kernel.org>,
       Mark Langsdorf <mark.langsdorf@amd.com>,
       Naga Chumbalkar <nagananda.chumbalkar@hp.com>
Subject: Re: [Bug #13780] NULL pointer dereference loading powernowk8
Message-ID: <20090916120110.GA9914@roeckx.be>
References: <aIL9jMAYJnG.A.WjH.M3BpKB@chimera>
 <200909080112.14997.rjw@sisk.pl>
 <20090908194653.GA3517@roeckx.be>
 <200909102259.15144.rjw@sisk.pl>
 <alpine.DEB.1.00.0909151642100.24059@chino.kir.corp.google.com>
 <20090916064708.GA25472@roeckx.be>
 <alpine.DEB.1.00.0909152359131.13366@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.00.0909152359131.13366@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 16, 2009 at 12:01:41AM -0700, David Rientjes wrote:
> On Wed, 16 Sep 2009, Kurt Roeckx wrote:
> > 
> > Please look at the patch I attached to the bug report.  There is
> > other code that is not equivalent.  It's in comment #17:
> > http://bugzilla.kernel.org/show_bug.cgi?id=13780#c17
> > 
> > And the patch itself:
> > http://bugzilla.kernel.org/attachment.cgi?id=23048
> > 
> > This patch fixes my problem.
> > 
> 
> Ah, I hadn't noticed you attached a patch there that fixes the issue for 
> you.  Is it en-route to Dave Jones so that it can make its way upstream?

I have no idea, so I would guess not.


Kurt

