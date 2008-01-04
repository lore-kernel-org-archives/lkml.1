Return-Path: <linux-kernel-owner+w=401wt.eu-S1756631AbYADJPt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756631AbYADJPt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 04:15:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753309AbYADJPf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 04:15:35 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:52835 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753266AbYADJPd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 04:15:33 -0500
Date: Fri, 4 Jan 2008 10:15:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@redhat.com>, hpa@rpath.com,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH x86] [10/16] Document fdimage/isoimage completely in
	make help
Message-ID: <20080104091511.GI28740@elte.hu>
References: <20080103442.621670000@suse.de> <20080103154224.47EA914DDB@wotan.suse.de> <20080104090043.GA28461@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080104090043.GA28461@uranus.ravnborg.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Sam Ravnborg <sam@ravnborg.org> wrote:

> On Thu, Jan 03, 2008 at 04:42:24PM +0100, Andi Kleen wrote:
> > 
> > Add missing targets and missing options in x86 make help
> > 
> > Cc: hpa@rpath.com
> > Cc: sam@ravnborg.org
> 
> Ingo - I assume you add this to x86.git.

yep, added it.

> PS. It looks like we have a tab embeded in the echo statements -
>     we should kill the remaining uses if thats correct.

yeah - fixed those.

	Ingo
