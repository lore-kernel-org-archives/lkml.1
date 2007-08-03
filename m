Return-Path: <linux-kernel-owner+w=401wt.eu-S1763626AbXHCPFs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763626AbXHCPFs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 11:05:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762682AbXHCPFl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 11:05:41 -0400
Received: from renko.ucs.ed.ac.uk ([129.215.13.3]:54890 "EHLO
	renko.ucs.ed.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762667AbXHCPFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 11:05:40 -0400
From: Alistair John Strachan <alistair@devzero.co.uk>
To: "T. J. Brumfield" <enderandrew@gmail.com>
Subject: Re: Scheduler Situation
Date: Fri, 3 Aug 2007 16:05:43 +0100
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
References: <cdc89fe60708030507r29283942mbb9947edbe04e23a@mail.gmail.com> <200708031540.29687.alistair@devzero.co.uk> <cdc89fe60708030751r459786dm588cfed7bc855813@mail.gmail.com>
In-Reply-To: <cdc89fe60708030751r459786dm588cfed7bc855813@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708031605.43563.alistair@devzero.co.uk>
X-Edinburgh-Scanned: at renko.ucs.ed.ac.uk
    with MIMEDefang 2.52, Sophie, Sophos Anti-Virus, Clam AntiVirus
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 03 August 2007 15:51:59 T. J. Brumfield wrote:
> > I'm not going to argue with this point because I think this is exactly
> > what Linus meant. He wanted a scheduler that worked. And he knew it
> > wouldn't work immediately after merging it. So he had to go with the
> > person that he trusted the most to make it work, quickly. And this was
> > Ingo. That might not be a "purely" technical reason, but I suspect it's a
> > correct one.
>
> You're demonstrating a lack of reason here.  In the same post Linus
> said repeatedly that he feels Con isn't someone he wanted to work with
> because he felt Con refused to listen to bug reports and was
> argumentative. 

Which is refuted only by your personal experience, not by any facts that have 
yet been posted.

> And never once did Linus say that CFS would work out  
> of the box.  He said it was new code that needs plenty of testing.  In
> fact he said that is why he was against plugsched, because if people
> ran different schedulers, then CFS would get less testing.  You're
> just putting motives in Linus' mouth that weren't there to begin with.

This has gone too far. I said NO such thing. I repeatedly stated in previous 
emails that the decision was based on code that, _although not perfect on 
submission_ could most rapidly be made to work. You have just twisted what 
I've said here to contradict that. Please read ALL of my emails, instead of 
selectively attacking only what you disagree with.

( I also don't appreciate being copied back onto LKML, after a long email 
diatribe (which you selectively did not copy). It's just bad netiquette. )

> > Who cares? You can't say either Linus or Ingo are any worse in this
> > regard, so it's irrelevant when discussing why SD wasn't chosen. This is
> > just as political as anything negative that Linus said.
>
> I imagine if it was your pet project, and you were trampled on in this
> manner, you'd care.  And I don't like seeing people abused like this.

I certainly wouldn't expect my code to be taken. If somebody else's was taken, 
I would accept that I was powerless to make them do otherwise. That's what 
benevolent dictatorships are all about and what somebody familiar with Linux 
development should expect.

The best way to deal with "injustices" is to constructively move past them. 
Con decided to leave the community, and that's another option. I just think 
everybody's lost out, himself included.

> I also don't care to see a project I care about weakened due to petty
> drama and politics.  I had hoped the Linux community was above this.
> Your lack of compassion in the matter however is duly noted.  We have
> polar views and aren't going to agree.

LKML isn't _normally_ a place for compassion, but for code, and I'm pretty 
sure that if there was less compassion we'd have fewer flamewars and less of 
the petty politics that you are complaining so loudly about.

Either you can convince Linus to change his mind, or you can't. Complaining 
about it will achieve nothing other than to increase the noise to signal on 
LKML.

-- 
Cheers,
Alistair.

137/1 Warrender Park Road, Edinburgh, UK.
