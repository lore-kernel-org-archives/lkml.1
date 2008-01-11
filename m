Return-Path: <linux-kernel-owner+w=401wt.eu-S1760608AbYAKJrw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760608AbYAKJrw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 04:47:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757925AbYAKJrp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 04:47:45 -0500
Received: from wa-out-1112.google.com ([209.85.146.176]:43112 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754714AbYAKJro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 04:47:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=kw/4ZnC29NE3aN5i3TkCAdfk/vELrbMgLkBCkqwDYTborU/bdUfEZD3sZ0HV8xKdSUHW34Z+R4MNXGLTkcBNLU1E7s3wA8cErYtN+9xOU6G+10oNdB5N0M4rm9GUoKE4BW8tVDwGt0PhEazdauTXe1PfF4c9sY7vdtOyUSrqWQ0=
Message-ID: <8bd0f97a0801110147w1cc741c3yc80ad32cd0e896c9@mail.gmail.com>
Date: Fri, 11 Jan 2008 04:47:44 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Pierre Ossman" <drzeus-mmc@drzeus.cx>
Subject: Re: [patch] split MMC_CAP_4_BIT_DATA
Cc: "Bryan Wu" <cooloney.lkml@gmail.com>, "Cai, Cliff" <Cliff.Cai@analog.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080111103532.2789b74f@poseidon.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <386072610801081832w2befcbafwe9215067f022ed5d@mail.gmail.com>
	 <20080109082325.212ec90d@poseidon.drzeus.cx>
	 <386072610801090845r14510fb8tbcca76d605458a96@mail.gmail.com>
	 <20080110095428.3b93fd18@poseidon.drzeus.cx>
	 <386072610801100122n52339488ke2b8724c390be765@mail.gmail.com>
	 <20080110125748.416ad0c5@poseidon.drzeus.cx>
	 <386072610801102217u1739d7d7v497e73a38aa876c2@mail.gmail.com>
	 <20080111094036.4c683791@poseidon.drzeus.cx>
	 <8bd0f97a0801110108l66ab2bcdjb1323573445473f@mail.gmail.com>
	 <20080111103532.2789b74f@poseidon.drzeus.cx>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 11, 2008 4:35 AM, Pierre Ossman <drzeus-mmc@drzeus.cx> wrote:
> "Mike Frysinger" <vapier.adi@gmail.com> wrote:
> > On Jan 11, 2008 3:40 AM, Pierre Ossman <drzeus-mmc@drzeus.cx> wrote:
> > > So it's far more probable that you've misdiagnosed your error than this being the actual problem.
> >
> > the guys who design the silicon are telling us it doesnt work.  our
> > tests show it not working.  i'm not sure what else you want here.
>
> More information. You have not provided any speculation as to why it doesn't work, or what you've done to figure it out. You haven't even described how it fails, just that it does. No information about what cards you've tested and how you've tested them to confirm that your theory on 4-bit data is accurate.

unfortunately, i cant fill these gaps myself directly.  all i bring to
the table is proper integration with the common frameworks.  i'm
relying on the guys developing the drivers and the guys who actually
designed the hardware for information.  they tell me it doesnt work, i
just believe them ;).

Cliff should be able to enumerate the cards he has tested and the
issues he's run into.  i'll see if i cant get more in depth
information from the hardware guys beyond the documentation on the sdh
already available in the hardware manual (which i'm guessing has not
been enough to appease you).

> You have no track record with me, and you're proposing something that goes against all known information. So you have to understand that I'm sceptical about your claims. I won't dismiss them off hand, but I need to be convinced you haven't made a mistake when coming to this conclusion.

that's fair.  i could actually be a gnome sitting outside in your
lawn.  you have no idea.
-mike
