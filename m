Return-Path: <linux-kernel-owner+w=401wt.eu-S1757575AbYG3UWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757575AbYG3UWl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 16:22:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755875AbYG3UWU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 16:22:20 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:53461 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755694AbYG3UWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 16:22:19 -0400
Message-ID: <4890CDF4.3010407@keyaccess.nl>
Date: Wed, 30 Jul 2008 22:24:20 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Adrian Bunk <bunk@kernel.org>, Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Jon Smirl <jonsmirl@gmail.com>, Paul Mundt <lethal@linux-sh.org>,
       James Morris <jmorris@namei.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, Dave Jones <davej@redhat.com>,
       Theodore Tso <tytso@mit.edu>, Simon Arlott <simon@fire.lp0.eu>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: 463 kernel developers missing!
References: <Xine.LNX.4.64.0807290751510.31732@us.intercode.com.au> <20080728234131.GD28055@linux-sh.org> <9e4733910807281714h2918fcbey77c8d1cea902a3fd@mail.gmail.com> <488E644D.7000507@keyaccess.nl> <9e4733910807281750p52cf150lacd0e237732046e7@mail.gmail.com> <488EF377.5080603@keyaccess.nl> <20080730072448.GB1564@cs181140183.pp.htv.fi> <4890284E.3050806@s5r6.in-berlin.de> <20080730124650.GB19966@cs181140183.pp.htv.fi> <4890646D.3060000@keyaccess.nl> <20080730153247.GA21597@cs181140183.pp.htv.fi> <alpine.LFD.1.10.0807300942450.3334@nehalem.linux-foundation.org> <4890C3D0.6070306@keyaccess.nl>
In-Reply-To: <4890C3D0.6070306@keyaccess.nl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30-07-08 21:41, Rene Herman wrote:

> So, if you were doing more than responding to Adrian's DCO worry here 
> (which I do not share) the above is what I have against harvesting the 
> addresses into a _way_ too public place/format. It's a matter of scale; 
> as opposed to the SCM metadata, your tree itself is way too public to 
> put anything in without very definite and explicit approval. I feel.

This, Jon, by the way also suggests something which I would consider 
much better; _keep_ it as SCM metadata in some less-accesible format 
under .git/

I doubt anyone's going to come up with an objection then. It's already 
in that exact same spot after all.

Rene.
