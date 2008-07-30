Return-Path: <linux-kernel-owner+w=401wt.eu-S1755713AbYG3U15@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755713AbYG3U15 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 16:27:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753177AbYG3U1t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 16:27:49 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:19436 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752940AbYG3U1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 16:27:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=tvZ0eSfP44343kZqu97UKyir5yDts+AhLH5CaMNLNv0Bm1J/BT/tzu8PETh5OtiB83
         VUPXiSa1httTWGyV9rR4vYi4rzLDuJnHmLlaWu0GnxL/Nnci6hsybbJx/o0ZYjcB9cpT
         QQhldivn5J8J28pah+SMP42/EHmDFfqQikxvE=
Message-ID: <9e4733910807301327k4f7e9d38h2453d46b98750c05@mail.gmail.com>
Date: Wed, 30 Jul 2008 16:27:46 -0400
From: "Jon Smirl" <jonsmirl@gmail.com>
To: "Rene Herman" <rene.herman@keyaccess.nl>
Subject: Re: 463 kernel developers missing!
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Adrian Bunk" <bunk@kernel.org>,
       "Stefan Richter" <stefanr@s5r6.in-berlin.de>,
       "Paul Mundt" <lethal@linux-sh.org>, "James Morris" <jmorris@namei.org>,
       "Randy Dunlap" <randy.dunlap@oracle.com>,
       "Dave Jones" <davej@redhat.com>, "Theodore Tso" <tytso@mit.edu>,
       "Simon Arlott" <simon@fire.lp0.eu>, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <4890CDF4.3010407@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Xine.LNX.4.64.0807290751510.31732@us.intercode.com.au>
	 <488EF377.5080603@keyaccess.nl>
	 <20080730072448.GB1564@cs181140183.pp.htv.fi>
	 <4890284E.3050806@s5r6.in-berlin.de>
	 <20080730124650.GB19966@cs181140183.pp.htv.fi>
	 <4890646D.3060000@keyaccess.nl>
	 <20080730153247.GA21597@cs181140183.pp.htv.fi>
	 <alpine.LFD.1.10.0807300942450.3334@nehalem.linux-foundation.org>
	 <4890C3D0.6070306@keyaccess.nl> <4890CDF4.3010407@keyaccess.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/30/08, Rene Herman <rene.herman@keyaccess.nl> wrote:
> On 30-07-08 21:41, Rene Herman wrote:
>
>
> > So, if you were doing more than responding to Adrian's DCO worry here
> (which I do not share) the above is what I have against harvesting the
> addresses into a _way_ too public place/format. It's a matter of scale; as
> opposed to the SCM metadata, your tree itself is way too public to put
> anything in without very definite and explicit approval. I feel.
> >
>
>  This, Jon, by the way also suggests something which I would consider much
> better; _keep_ it as SCM metadata in some less-accesible format under .git/

The decision to keep it in .mailmap format was made before I was
involved. A smaller .mailmap has been in the tree since 2007. Existing
tools will need to be changed if the location is moved.

>
>  I doubt anyone's going to come up with an objection then. It's already in
> that exact same spot after all.
>
>  Rene.
>


-- 
Jon Smirl
jonsmirl@gmail.com
