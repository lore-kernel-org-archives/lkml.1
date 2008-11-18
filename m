Return-Path: <linux-kernel-owner+w=401wt.eu-S1755246AbYKRRRZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246AbYKRRRZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 12:17:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754926AbYKRRNx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 12:13:53 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:53996 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755214AbYKRRNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 12:13:52 -0500
Date: Tue, 18 Nov 2008 18:13:51 +0100
From: Pavel Machek <pavel@suse.cz>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Miklos Szeredi <miklos@szeredi.hu>, hpa@zytor.com, multinymous@gmail.com,
       jrm8005@gmail.com, tpctl-users@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [Tpctl-users] Inclusion of tp_smapi module into kernel?
Message-ID: <20081118171350.GA13671@atrey.karlin.mff.cuni.cz>
References: <200811171455.50039.hanno@hboeck.de> <49219DF5.5040404@zytor.com> <3aaafc130811170913o761ce43fg3a2738586ebd2396@mail.gmail.com> <41840b750811171035w63c794aepaa273bc55fbaf2@mail.gmail.com> <4921C425.7020806@zytor.com> <E1L2Aog-0007g9-94@pomaz-ex.szeredi.hu> <20081118134847.GD18285@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081118134847.GD18285@khazad-dum.debian.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, 17 Nov 2008, Miklos Szeredi wrote:
> > On Mon, 17 Nov 2008, H. Peter Anvin wrote:
> > > Shem Multinymous wrote:
> > > > On Mon, Nov 17, 2008 at 12:13 PM, J.R. Mauro <jrm8005@gmail.com> wrote:
> > > >> There are several utilities maintained by this author, and finding
> > > >> some way to merge the code has been tried more than once. If you look
> > > >> back far enough, Andrew asked to have another of the project's members
> > > >> sign off on the patch, and maybe that would be acceptable enough, but
> > > >> afaik the author has never responded directly to that idea.
> > > > 
> > > > We've discussed that in private at the time, and recently on LKML too.
> > > > In summary:
> > > > I'm fine with that, and so is everybody I talked to (including Linus),
> > > > except Greg KH who vetoed it since he believes the code is irrevocably
> > > > and contagiously evil.
> > > > 
> > > 
> > > Signed-off-by is about copyright, it's not a review issue.  It means "I 
> > > certify that I know that the author had the rights to submit this code." 
> > >    Code quality is important but separate.
> > 
> > We've discussed this issue on the internal suse mailing lists, and
> > concluded that the solution is simple: someone from IBM, Lenovo or
> > whoever they license the technology from should sign off on the code.
> 
> That would be nice, yes.
> 
> > But implementing this got stuck at some stage.
> > 
> > Can anybody help with info about who's responsible for this part of
> > the ThinkPad?
> 
> SuSE has direct management-level and engineering-level contacts with the
> Lenovo team responsible for the ThinkPad.  IMO, the contact needs to be done
> through those channels (which are Linux-friendly).
> 
> If SuSE decided not to do it, they must have had their reasons.  I wouldn't
> know them, but I can guess as much as anyone else, and my pet guess is that
> they are waiting for an opportune time.

SuSE asked, Lenovo said no. We can probably try again...
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
