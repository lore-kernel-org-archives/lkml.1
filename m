Return-Path: <linux-kernel-owner+w=401wt.eu-S1753194AbYKRNtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194AbYKRNtV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 08:49:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752429AbYKRNsw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 08:48:52 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:54883 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752321AbYKRNsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 08:48:51 -0500
X-Sasl-enc: 1qoWm2fpqn3u94OyjOFhmyRu4QMSYHvovtRxezFgqjqG 1227016129
Date: Tue, 18 Nov 2008 11:48:47 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: hpa@zytor.com, multinymous@gmail.com, jrm8005@gmail.com,
       tpctl-users@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [Tpctl-users] Inclusion of tp_smapi module into kernel?
Message-ID: <20081118134847.GD18285@khazad-dum.debian.net>
References: <200811171455.50039.hanno@hboeck.de> <49219DF5.5040404@zytor.com> <3aaafc130811170913o761ce43fg3a2738586ebd2396@mail.gmail.com> <41840b750811171035w63c794aepaa273bc55fbaf2@mail.gmail.com> <4921C425.7020806@zytor.com> <E1L2Aog-0007g9-94@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1L2Aog-0007g9-94@pomaz-ex.szeredi.hu>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Nov 2008, Miklos Szeredi wrote:
> On Mon, 17 Nov 2008, H. Peter Anvin wrote:
> > Shem Multinymous wrote:
> > > On Mon, Nov 17, 2008 at 12:13 PM, J.R. Mauro <jrm8005@gmail.com> wrote:
> > >> There are several utilities maintained by this author, and finding
> > >> some way to merge the code has been tried more than once. If you look
> > >> back far enough, Andrew asked to have another of the project's members
> > >> sign off on the patch, and maybe that would be acceptable enough, but
> > >> afaik the author has never responded directly to that idea.
> > > 
> > > We've discussed that in private at the time, and recently on LKML too.
> > > In summary:
> > > I'm fine with that, and so is everybody I talked to (including Linus),
> > > except Greg KH who vetoed it since he believes the code is irrevocably
> > > and contagiously evil.
> > > 
> > 
> > Signed-off-by is about copyright, it's not a review issue.  It means "I 
> > certify that I know that the author had the rights to submit this code." 
> >    Code quality is important but separate.
> 
> We've discussed this issue on the internal suse mailing lists, and
> concluded that the solution is simple: someone from IBM, Lenovo or
> whoever they license the technology from should sign off on the code.

That would be nice, yes.

> But implementing this got stuck at some stage.
> 
> Can anybody help with info about who's responsible for this part of
> the ThinkPad?

SuSE has direct management-level and engineering-level contacts with the
Lenovo team responsible for the ThinkPad.  IMO, the contact needs to be done
through those channels (which are Linux-friendly).

If SuSE decided not to do it, they must have had their reasons.  I wouldn't
know them, but I can guess as much as anyone else, and my pet guess is that
they are waiting for an opportune time.

If you work with SuSE, you could try to use your internal channels to find
out what really is happening.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
