Return-Path: <linux-kernel-owner+w=401wt.eu-S1030568AbXAYVJq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030568AbXAYVJq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 16:09:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030570AbXAYVJq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 16:09:46 -0500
Received: from raven.upol.cz ([158.194.120.4]:45270 "EHLO raven.upol.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030568AbXAYVJp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 16:09:45 -0500
Date: Thu, 25 Jan 2007 21:18:02 +0000
To: Rob Landley <rob@landley.net>
Cc: Andrew Morton <akpm@osdl.org>, Sam Ravnborg <sam@ravnborg.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: sed _s_gnu_alternatives_ (Re: [rft] (g)awk substitution)
Message-ID: <20070125211802.GC10907@flower.upol.cz>
References: <200701151624.18033.rob@landley.net> <200701251303.33607.rob@landley.net> <20070125191407.GA10853@flower.upol.cz> <200701251438.03213.rob@landley.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200701251438.03213.rob@landley.net>
Organization: Palacky University in Olomouc, experimental physics department.
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 25, 2007 at 02:38:02PM -0500, Rob Landley wrote:
> On Thursday 25 January 2007 2:14 pm, Oleg Verych wrote:
> > > I believe "shift 5" is also SUSv3. :)
> > 
> > If you have tested, please send ack or nack to us.
> 
> I have not.  I tested the one I sent.  Today I'm at a different location than 
> that test environment.  All I can try it on here is Ubuntu, and so could you 
> just as easily.
> 
> As I said, I'm not particularly interested in a more intrusive solution 
> solving a problem I haven't actually seen.  I don't see any obvious reason 
> why it wouldn't work, and yes it would probably also solve my problem, but I 
> still don't see why you think it's "better" than the three byte fix.

Ehhh. "I'm not guilty" issue. Well, fine ;)

If your current system is IA-32, or you have access to one, would you
like to test scripts/makelst for me, as i'm seeing `bc' there. But my
system have not one, i would like to replace it with shell or awk or
whatever. TIA.

____
