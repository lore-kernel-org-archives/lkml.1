Return-Path: <linux-kernel-owner+w=401wt.eu-S1753843AbYKQUfv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753843AbYKQUfv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 15:35:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752178AbYKQUfn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 15:35:43 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:53361 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752152AbYKQUfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 15:35:42 -0500
To: hpa@zytor.com
CC: multinymous@gmail.com, jrm8005@gmail.com,
       tpctl-users@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-reply-to: <4921C425.7020806@zytor.com> (hpa@zytor.com)
Subject: Re: [Tpctl-users] Inclusion of tp_smapi module into kernel?
References: <200811171455.50039.hanno@hboeck.de> <49219DF5.5040404@zytor.com>	 <3aaafc130811170913o761ce43fg3a2738586ebd2396@mail.gmail.com> <41840b750811171035w63c794aepaa273bc55fbaf2@mail.gmail.com> <4921C425.7020806@zytor.com>
Message-Id: <E1L2Aog-0007g9-94@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 17 Nov 2008 21:35:26 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Nov 2008, H. Peter Anvin wrote:
> Shem Multinymous wrote:
> > On Mon, Nov 17, 2008 at 12:13 PM, J.R. Mauro <jrm8005@gmail.com> wrote:
> >> There are several utilities maintained by this author, and finding
> >> some way to merge the code has been tried more than once. If you look
> >> back far enough, Andrew asked to have another of the project's members
> >> sign off on the patch, and maybe that would be acceptable enough, but
> >> afaik the author has never responded directly to that idea.
> > 
> > We've discussed that in private at the time, and recently on LKML too.
> > In summary:
> > I'm fine with that, and so is everybody I talked to (including Linus),
> > except Greg KH who vetoed it since he believes the code is irrevocably
> > and contagiously evil.
> > 
> 
> Signed-off-by is about copyright, it's not a review issue.  It means "I 
> certify that I know that the author had the rights to submit this code." 
>    Code quality is important but separate.

We've discussed this issue on the internal suse mailing lists, and
concluded that the solution is simple: someone from IBM, Lenovo or
whoever they license the technology from should sign off on the code.
But implementing this got stuck at some stage.

Can anybody help with info about who's responsible for this part of
the ThinkPad?

Thanks,
Miklos
