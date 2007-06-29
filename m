Return-Path: <linux-kernel-owner+w=401wt.eu-S932722AbXF2Mih@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932722AbXF2Mih (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 08:38:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758332AbXF2Mia
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 08:38:30 -0400
Received: from mail-in-02.arcor-online.net ([151.189.21.42]:55347 "EHLO
	mail-in-02.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752825AbXF2Mi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 08:38:29 -0400
From: Florian Schmidt <mista.tapas@gmx.net>
To: Anton Petrusevich <casus@casus.us>
Subject: Re: Is it time for remove (crap) ALSA from kernel tree ?
Date: Fri, 29 Jun 2007 14:38:27 +0200
User-Agent: KMail/1.9.6
Cc: Rene Herman <rene.herman@gmail.com>, linux-kernel@vger.kernel.org,
       alsa-devel@lists.sourceforge.net
References: <200706281442.05239.casus@casus.us> <200706291230.54175.mista.tapas@gmx.net> <200706291340.43251.casus@casus.us>
In-Reply-To: <200706291340.43251.casus@casus.us>
X-Face: %EpW[IH18fBP*R?oz~]%Klbl.q!_(Xs_q"t?K~RVx[c7~3|C3kDdA(8y_KOB\{(Rn(=?iso-8859-15?q?MZhm=0A=09=7B/l=2E?=>O48>i9k<+(,c^Y%mGm)M\+RxuxL4r<7-W63sB$+w\}hkT"Q2?v&N:y\Z
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200706291438.27173.mista.tapas@gmx.net>
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 29 June 2007, Anton Petrusevich wrote:
> On Friday 29 June 2007 12:30:54 Florian Schmidt wrote:
> > Sadly it seems pretty much everyone, especially closed source apps get
> > this wrong (but to be fair: loads of open source software gets it wrong,
> > too, ekiga for example).
>
> Isn't that because there's a perferct documentation for programming ALSA
> but authors of those apps can't read?

No, like i said, the docs are unclear on these issues :) That's why so many 
people get it wrong.

> But in real life I have to use flashplayer, for example.

Yes, in these cases flashplayer should use either the default pcm device 
[which the user can then tweak to his liking] or provide some means to 
configure it. for example via a dotfile in the user's homedir. This is not 
ALSA's fault.

> I am with Linux since 1997, I know bunch of them. I used to use XEmacs, but
> now I prefer VIM. But I am not a .asoundrc programmer, I want to be just a
> user.

I agree that it would be nice to have a tool to select the default device in 
ALSA. 

> > But skype is a piece of crap anyways. It also doesn't get any sounds out
> > of my other [non ice1712] card. Neither in OSS nor in ALSA mode. Not a
> > beep. And yeah, the device is available [and even has hardware
> > multiplexing]..
> >
> > But 99.9% of problems people have with ALSA are due to badly coded apps..
>
> "Those apps are crap and ALSA is perfect". I hoped some ALSA-developers
> would think of improving usability of ALSA, or I would not talk here.

ALSA must be improved, too.  But that doesn't change a thing about these apps 
misusing the ALSA API and people blaming ALSA lateron. Which is wrong.

> It's good that people are not thinking that ALSA is already perfect, it
> leaves us (me) a hope it will be improved.

I don't think any serious person believes that ALSA is perfect :)

Regards,
Flo

-- 
Palimm Palimm!
http://tapas.affenbande.org
