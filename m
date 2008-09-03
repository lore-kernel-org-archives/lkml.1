Return-Path: <linux-kernel-owner+w=401wt.eu-S1754593AbYICUEQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593AbYICUEQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 16:04:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754710AbYICUDq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 16:03:46 -0400
Received: from styx.suse.cz ([82.119.242.94]:46285 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754499AbYICUDp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 16:03:45 -0400
Date: Wed, 3 Sep 2008 22:03:43 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
cc: Daniel Barkalow <barkalow@iabervon.org>, linux-kernel@vger.kernel.org,
       Christopher Desjardins <cddesjardins@gmail.com>
Subject: Re: Lenovo 3000 N100 i8042 problems
In-Reply-To: <20080903150241.ZZRA012@mailhub.coreip.homeip.net>
Message-ID: <alpine.LNX.1.10.0809032201050.23448@jikos.suse.cz>
References: <alpine.LNX.1.00.0808240148580.19665@iabervon.org> <Pine.LNX.4.64.0809020120130.29111@twin.jikos.cz> <alpine.LNX.1.00.0809012014280.19665@iabervon.org> <alpine.LNX.1.10.0809021121410.23448@jikos.suse.cz> <20080902083940.ZZRA012@mailhub.coreip.homeip.net>
 <alpine.LNX.1.00.0809021200470.19665@iabervon.org> <20080903102047.ZZRA012@mailhub.coreip.homeip.net> <alpine.LNX.1.00.0809031250561.19665@iabervon.org> <20080903150241.ZZRA012@mailhub.coreip.homeip.net>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Sep 2008, Dmitry Torokhov wrote:

> > I'm not seeing that on any kernel with this hardware.
> I understand. Jiri, how did active MUX problem manifest on
> Cristopher's box?

If Christopher doesn't respond himself, I will dig it out from my 
archives, it has been quite some time already since this has been 
originally reported.

If I remember correctly, when 'nomux' wasn't used, psmouse used to 
complain a lot about losing synchronization and then the mouse pointer 
either went crazy or froze completely.

Christoph?

Thanks,

-- 
Jiri Kosina
SUSE Labs
