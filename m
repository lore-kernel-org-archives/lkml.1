Return-Path: <linux-kernel-owner+w=401wt.eu-S1754218AbZEQCxb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218AbZEQCxb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 22:53:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752176AbZEQCxW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 22:53:22 -0400
Received: from mail-qy0-f112.google.com ([209.85.221.112]:58120 "EHLO
	mail-qy0-f112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107AbZEQCxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 22:53:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=eoUwMt1MjSUtvEEfJMKb3pzmMa49RxC5p+oIU87dG4LE5QLnxXlWqHvScTe0KbqR+l
         k4ymMyPVNr9T36qpd246iM0VMBynAVstXW4QaH/9LW7xeVx55VAR9o/z7kVlSOWBKGWm
         A6y5R1sA2MQM2l5XMDqiHFA8Bp9s/tfwKL9r8=
MIME-Version: 1.0
In-Reply-To: <200905162107.58677.Martin@lichtvoll.de>
References: <1241620755-22133-1-git-send-email-nigel@tuxonice.net>
	 <200905162107.58677.Martin@lichtvoll.de>
Date: Sat, 16 May 2009 22:53:22 -0400
Message-ID: <f22f52180905161953t6248e60fg3f6732a04d59b406@mail.gmail.com>
Subject: Re: [TuxOnIce-devel] [RFC] TuxOnIce
From: Matt Price <moptop99@gmail.com>
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: tuxonice-devel@lists.tuxonice.net, linux-pm@lists.linux-foundation.org,
       Nigel Cunningham <nigel@tuxonice.net>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 16, 2009 at 3:07 PM, Martin Steigerwald <Martin@lichtvoll.de> wrote:
> Am Mittwoch 06 Mai 2009 schrieb Nigel Cunningham:
>> I'd like to submit TuxOnIce for review, with a view to seeking to get
>> it merged, perhaps in 2.6.31 or .32 (depending upon what needs work
>> before it can be merged) and the willingness of those who matter.
>>
>> To briefly summarise the advantages to merging TuxOnIce:
>
> As a user I support this.
>
> Why?
>
> Cause everytime I tried TuxOnIce just worked while I had various problems
> whenever I tried out any in-kernel snapshot stuff, be it hard-wired or
> userspace supported. Actually I never could have been bothered to try out
> to fix any issues with these while I just had a working solution and
> thats TuxOnIce. Might have been that issues could have been fixed - but
> exactly why should I care when I have something that just works? Honestly
> I can't even be bothered to remember those issues in detail. It was
> crashes, hangs and on the last occurence of testing mostly slowness while
> it basically worked mostly. Release versions of TuxOnIce didn't fail for
> me as long as I can remember.
>
just to amplify on this a little bit:  as a user, I found that
whatever problems I ran into with TuxOnIce I could actually get fixed.
 This has been a result of :
a) a lively user/dev community of people, obviously including Nigel
himself, who take each other's problems issues seriously; and
b) dramatically superior debugging information provided by the
tuxonice implementation.  when something fails with tuxonice, it's
quite easy to narrow down the issue.  with swsusp, my experience has
always been that there's more or less no log information to work with;
and if you do have the luck to have some usable info in your logs,
there's no one around willing to help you figure the problem out
anyway.

one of the real frustrations i've had watching this process from the
sidelines is that those with the authority to make decisions have
never taken either of these very important concerns seriously.  And
until they do, I do think it's quite likely that suspend-to-disk will
continue in its largely-broken state for quite some time to come.

matt
