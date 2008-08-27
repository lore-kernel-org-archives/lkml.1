Return-Path: <linux-kernel-owner+w=401wt.eu-S1755980AbYH0NNg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755980AbYH0NNg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 09:13:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754858AbYH0NN1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 09:13:27 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2687 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754788AbYH0NN0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 09:13:26 -0400
Date: Wed, 27 Aug 2008 15:13:13 +0200
From: Pavel Machek <pavel@suse.cz>
To: Avi Kivity <avi@qumranet.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] x86: default to reboot via ACPI
Message-ID: <20080827131312.GA6221@ucw.cz>
References: <1219659087-17536-1-git-send-email-avi@qumranet.com> <20080826095032.GA309@elf.ucw.cz> <48B3D579.40502@qumranet.com> <20080826113317.520cbab1@lxorguk.ukuu.org.uk> <48B3F3A9.8030709@qumranet.com> <Pine.LNX.4.55.0808261406330.28361@cliff.in.clinika.pl> <87fxorsqdx.fsf@basil.nowhere.org> <20080827091810.GB1688@elf.ucw.cz> <48B531BD.20608@qumranet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48B531BD.20608@qumranet.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2008-08-27 13:51:41, Avi Kivity wrote:
> Pavel Machek wrote:
> >I'd not count of this. When you relegate laptop to 
> >"quiet home server"
> >role, the mechanical stresses suddenly stop, and I'd 
> >expect it to
> >survive for long long years.
> >  
> 
> For every user who uses an old laptop as a home server, 
> or has a "best MIPS64 box", there are maybe five million 
> users with a 0-3 year old x86 computer (they don't know 
> that it's really a "box").

Five million... um yes, probably, and those five million users run
Windows Vista...

So lets not introduce regressions, please.

(Anyway, the patch is probably good, but 'old machines do not matter'
is not.)
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
