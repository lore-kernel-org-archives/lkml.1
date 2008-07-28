Return-Path: <linux-kernel-owner+w=401wt.eu-S1759439AbYG1Wwg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759439AbYG1Wwg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 18:52:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752752AbYG1Ww1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 18:52:27 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:42245 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064AbYG1Ww0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 18:52:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=eGjX9r/eFiqaE/aU2mAy8nanRyf3+SVjKtMFupfndo/bgAPPHMEmQ+m6/vEh1KSC9A
         zT1gEq0QgJFgSFUqAYWQngttOoSfUOqUEp17CDNj/gaS6CCFcul58wciAk7mxJbF88iE
         wDKko47MHRjsG7prqImTCzJf+Us7yn341/GL8=
Message-ID: <9e4733910807281552h6e72ec21q6555be2886b418f0@mail.gmail.com>
Date: Mon, 28 Jul 2008 18:52:25 -0400
From: "Jon Smirl" <jonsmirl@gmail.com>
To: "Theodore Tso" <tytso@mit.edu>, "Dave Jones" <davej@redhat.com>,
       "Simon Arlott" <simon@fire.lp0.eu>, lkml <linux-kernel@vger.kernel.org>,
       "Randy Dunlap" <randy.dunlap@oracle.com>
Subject: Re: 463 kernel developers missing!
In-Reply-To: <20080728223241.GR9378@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9e4733910807281005y62dca90ar96f663908e644546@mail.gmail.com>
	 <9e4733910807281022v38d323c9sc7b63235824690f6@mail.gmail.com>
	 <488E0BB6.7020006@simon.arlott.org.uk>
	 <9e4733910807281119m10f9b6e3v98fc892a42476c86@mail.gmail.com>
	 <488E1147.5040803@simon.arlott.org.uk>
	 <9e4733910807281200m25f7f16bwa6678694bb25a61@mail.gmail.com>
	 <20080728202236.GN9378@mit.edu> <20080728204624.GA11581@redhat.com>
	 <9e4733910807281508v5d348d53la59eeea8e2fabb67@mail.gmail.com>
	 <20080728223241.GR9378@mit.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/28/08, Theodore Tso <tytso@mit.edu> wrote:
> On Mon, Jul 28, 2008 at 06:08:33PM -0400, Jon Smirl wrote:
>  > I didn't do this to measure statistics, I did it because I was writing
>  > a script and the script was getting garbage for input. It just had the
>  > side effect of cleaning up the statistics.
>
>
> Out of curiosity, what is your script trying to do?

I was trying to locate my patches in other private trees that were
ready for deletion. I wanted to make sure there wasn't something good
that I had forgotten about. I processed the output from 'git log' and
got tripped up matching the author field because is was full of junk.
My database background kicked in and I found myself on a tangent
cleaning up the data.

I have since learned about the existence of 'git shortlog' which
solved my problem. But I had already cleaned up the data before
finding it.

>
>                                                 - Ted
>


-- 
Jon Smirl
jonsmirl@gmail.com
