Return-Path: <linux-kernel-owner+w=401wt.eu-S964843AbXBPNok@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964843AbXBPNok (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 08:44:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964845AbXBPNok
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 08:44:40 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:41061 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964843AbXBPNoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 08:44:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=IM5wYTkHHXpGUkc1Xi4EYe8+LxtN4oQ5GTwF9xMGe1HK99/GYYX7GatTQ8GLIV1f+AhTasitu0Q5fBm1YgFsfKevnZQLbrKTmXSrPVAu41JTkKOt5+c/n24RRewCe4bRoa4pZMgp3I0tU4Fq2TP0QK251srYR31UoebGMuQwgS4=
Message-ID: <3d57814d0702160544o14a51278k511b65f51ca1d229@mail.gmail.com>
Date: Fri, 16 Feb 2007 23:44:35 +1000
From: "Trent Waddington" <trent.waddington@gmail.com>
To: "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>
Subject: Re: GPL vs non-GPL device drivers
Cc: "v j" <vj.linux@gmail.com>, "David Lang" <david.lang@digitalinsight.com>,
       "Scott Preece" <sepreece@gmail.com>,
       "Miguel Ojeda" <maxextreme@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <200702160952.l1G9qMsY025262@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9b3a62ab0702142115m4ea7d2c0m6869eb64ef3ee14e@mail.gmail.com>
	 <20070215165339.GB5285@thunk.org>
	 <9b3a62ab0702151020k5bd0e4c9w763e1b01288ccc4f@mail.gmail.com>
	 <653402b90702151102n3a3e0435r837e2191de79b2b@mail.gmail.com>
	 <7b69d1470702151712x685f3e0eqf6198f9bb7f2394e@mail.gmail.com>
	 <Pine.LNX.4.63.0702151701510.10070@qynat.qvtvafvgr.pbz>
	 <9b3a62ab0702152148p57db8b1dgd42b1c6fb15dccbb@mail.gmail.com>
	 <3d57814d0702152157n461a9f0cta0a0c20e9a592d83@mail.gmail.com>
	 <9b3a62ab0702152225m3893318by95cb8b260c74bfc2@mail.gmail.com>
	 <200702160952.l1G9qMsY025262@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/16/07, Valdis.Kletnieks@vt.edu <Valdis.Kletnieks@vt.edu> wrote:
> As others have pointed out, NVidia and ATI think they're in an OK spot with
> the way *they* do *their* module,

Man, your sentence is so vague here that I almost don't feel the need
to correct you, almost.  I don't think NVIDIA or ATI think they can
get away with distributing a binary only kernel module because of any
of the technical measures they take to seperate themselves from the
kernel code.. That's done for good technical reasons, they ship *BSD
drivers too.

I think the reason why they feel safe that no-one will sue them (and
no company wants to be sued, even big ones by individual kernel
developers) is because so few kernel developers have actually sued
anyone for writing proprietary drivers.

So here's my message to VJ, from a legal standpoint: don't worry about
it.  No-one who authored code you're linking your code against is
likely to go on a suing spree anytime soon, they're too busy coding.

You've already got my message from a moral point of view (and I'm
still terribly confused about your reply).

Trent
