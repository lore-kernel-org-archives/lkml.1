Return-Path: <linux-kernel-owner+w=401wt.eu-S1763361AbXHCOwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763361AbXHCOwW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 10:52:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762894AbXHCOwB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 10:52:01 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:11411 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762780AbXHCOwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 10:52:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Pwr0ovg+qdxtHEEp/tMfZb7KvnAvG5rcZ2vAdmbtLsWs6/oZNHGUCzP3c4SSb0CiqZz4rL8SA+/91kzCg4RcPx+k2xHEGHWMAl1q2WYJ45qq09iWoRPOprJycZdIWDmgO9ronXIMqFbqlnh2emSKGf/qGximefN/EjJzZg7GerI=
Message-ID: <cdc89fe60708030751r459786dm588cfed7bc855813@mail.gmail.com>
Date: Fri, 3 Aug 2007 09:51:59 -0500
From: "T. J. Brumfield" <enderandrew@gmail.com>
To: "Alistair John Strachan" <alistair@devzero.co.uk>
Subject: Re: Scheduler Situation
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200708031540.29687.alistair@devzero.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <cdc89fe60708030507r29283942mbb9947edbe04e23a@mail.gmail.com>
	 <200708031354.15485.alistair@devzero.co.uk>
	 <cdc89fe60708030712q391de609o3999a870ea7cbcbd@mail.gmail.com>
	 <200708031540.29687.alistair@devzero.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm not going to argue with this point because I think this is exactly what
> Linus meant. He wanted a scheduler that worked. And he knew it wouldn't work
> immediately after merging it. So he had to go with the person that he trusted
> the most to make it work, quickly. And this was Ingo. That might not be
> a "purely" technical reason, but I suspect it's a correct one.

You're demonstrating a lack of reason here.  In the same post Linus
said repeatedly that he feels Con isn't someone he wanted to work with
because he felt Con refused to listen to bug reports and was
argumentative.  And never once did Linus say that CFS would work out
of the box.  He said it was new code that needs plenty of testing.  In
fact he said that is why he was against plugsched, because if people
ran different schedulers, then CFS would get less testing.  You're
just putting motives in Linus' mouth that weren't there to begin with.

He picked a person over a piece of code, and his reasoning for picking
a person was flawed.  By Linus' own statements we should choose a
person who has demonstrated they could support scheduler code for
years.  Con did exactly that, where as Ingo said he never imagined
he'd write a scheduler.  Linus made up some bogus accusations about
Con and that isn't cool.  I'm not sure why anyone would argue this
point.  Attacking volunteers in a volunteer project is just bad form,
and my entire purpose of ever writing this list that already gets far
too much traffic is to voice my displeasure in exactly this matter.
I've always respected Linus despite his many public disputes.
Generally he argues his point gruffly, but he has reason and logic on
his side.  Here he has a personal grudge, and the community is weaker
now because of it.

> Who cares? You can't say either Linus or Ingo are any worse in this regard, so
> it's irrelevant when discussing why SD wasn't chosen. This is just as
> political as anything negative that Linus said.

I imagine if it was your pet project, and you were trampled on in this
manner, you'd care.  And I don't like seeing people abused like this.
I also don't care to see a project I care about weakened due to petty
drama and politics.  I had hoped the Linux community was above this.
Your lack of compassion in the matter however is duly noted.  We have
polar views and aren't going to agree.

I'll leave it at that.

-- T. J. Brumfield
"In the beginning the Universe was created. This has made a lot of
people very angry and been widely regarded as a bad move."
--Douglas Adams
"Nihilism makes me smile."
--Christopher Quick
