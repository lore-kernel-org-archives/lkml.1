Return-Path: <linux-kernel-owner+w=401wt.eu-S1760154AbYBSJfn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760154AbYBSJfn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 04:35:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751613AbYBSJfd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 04:35:33 -0500
Received: from one.firstfloor.org ([213.235.205.2]:49928 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141AbYBSJfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 04:35:32 -0500
Date: Tue, 19 Feb 2008 10:35:34 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, Arjan van de Ven <arjan@infradead.org>,
       Frans Pop <elendil@planet.nl>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Unable to continue testing of 2.6.25
Message-ID: <20080219093534.GC6485@one.firstfloor.org>
References: <200802171025.30590.elendil@planet.nl> <20080217124650.576990ce@laptopd505.fenrus.org> <p73mypyxx6z.fsf@bingen.suse.de> <20080218085018.05f3190a@laptopd505.fenrus.org> <20080218171159.GA24090@basil.nowhere.org> <20080218093215.5cf611a8@laptopd505.fenrus.org> <20080218185228.GA29026@one.firstfloor.org> <20080218191841.GB2125@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080218191841.GB2125@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 18, 2008 at 08:18:41PM +0100, Ingo Molnar wrote:
> 
> * Andi Kleen <andi@firstfloor.org> wrote:
> 
> > > I've yet to see a user who wants WC. Lets face it, WC *sucks*. This 
> > > is why
> > 
> > Interesting.
> 
> does this refresh your memory:
> 
>   http://lkml.org/lkml/2008/1/10/99

I'm still far from convinced it covers all cases (see also Roland's example)
Arjan might be right for some modern graphics hardware, but there is
a lot more hardware out there than only this, old and new and non graphics
and graphics that Arjan didn't cover.

If Arjan was 100% right then PAT would not be needed at all. I wonder
why Venki/Suresh went through all the pain of resurrecting the old
PAT patchkit then!? Surely there is more about this.

-Andi
