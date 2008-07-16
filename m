Return-Path: <linux-kernel-owner+w=401wt.eu-S1759537AbYGPQFV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759537AbYGPQFV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 12:05:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757318AbYGPQFJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 12:05:09 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:21160 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756201AbYGPQFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 12:05:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=nV7SbIdG/yTszd004j8YL19GmE/4+j7gQAx8c6fhOZkkBiudBO4M0UCUf7QBhq6C0g
         P7tDgOvy53XXHjMAuUd48Bsksf25QoVnpC7FazKWaSXJYxBAvOo3gGsKSen6ljAUchaI
         WzgqT7njl/4xNXhob8DTeUnbLq29PleAk6Ry4=
Message-ID: <67b4e5f30807160905n224a7808tf346dd4d506edd25@mail.gmail.com>
Date: Wed, 16 Jul 2008 16:05:07 +0000
From: "Cheradenine Zakalwe" <sc.contact@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: The state of linux security
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Right, for a start, if I was a professor at university I'd much rather
some "smart" students crashed 100 boxes a day for a year than one
owned several servers.  In any case, it seems absurd that anybody
looking for security holes to either subvert or crash systems would be
deterred by the lack of security commit messages.  They already know
what they are looking for.  On the other hand, there has to be some
metrics available for normal people to make an informed decision about
the relative security of linux and the likely hood that smart people
are able to cause a bit of mindless vandalism or get up to much worse.

Your hand waving and obfuscation simply do not wash.  The bugs being
talked about are not just any bugs.  They have their own commercial
value because they can allow the complete subversion of your systems.
This (for most people I'd guess) is far more dangerous than simply
having their computers crash.  Also, I'd bet that many security bugs
aren't triggerable under any normal workload.  If my machines have
been running for 2 months why bother bringing them down in order to
bugfix something that doesn't seem to affect them anyway?

This business of passing the buck onto vendors is also absurd.  If
security is not built into your development mindset and models from
the start you are being utterly naive and complacent.  I commend the
stable team for fixing and backporting what they can, but I need to
know what I've been exposed to and for how long.  From the looks of
what the paxteam has been saying, it seems linux security is pretty
bad and has been getting worse.  This must be in no small part to you
putting your head in the sand, sticking your fingers in your ears and
going "lalalalala".

Obfuscating the risk people are exposed to means you have no real
accountability and thus no incentive to not put so many security bugs
there in the first place.  If other developers or users don't know how
bad things are how can they make informed decisions about development
processes or where they can afford to deploy linux?

If it turns out that the current development model has produced too
many security problems then the development model must change. I'd
like to think that the integrity of most peoples systems is more
important than some micro benchmark improvement because of some
complex scheduler change.  That's not to say the latter isn't
important, just that more time and effort needs to be put into making
sure that the changes don't affect users in potentially disasterous
ways.

One more thing I'd like to throw out there on the issue of
accountability is this:  How do I know that some developers have not
been paid to specifically introduce some obscure security flaw?  Given
that such subversions happen frequently in every other field of human
endeavour where potential profit is involved, this is not beyond the
realms of possibility.  The more linux is adopted the more likely this
is to become a real issue.  For that reason it is imperitive that
these potentially severe flaws are dealt with openly and transparantly
when discovered.

If the attitudes of the people at the top of linux development don't
change this is the end of the linux experiment for me and i'm sure
many other people.  The percieved benifits of transparancy, openness
and cost will have been completely smashed for the vast majority of
users.  This is not something to be taken lightly.
