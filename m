Return-Path: <linux-kernel-owner+w=401wt.eu-S1754099AbYFYUor@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099AbYFYUor (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 16:44:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752116AbYFYUoi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 16:44:38 -0400
Received: from mail.gmx.net ([213.165.64.20]:60251 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751688AbYFYUoh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 16:44:37 -0400
X-Authenticated: #19095397
X-Provags-ID: V01U2FsdGVkX1+dm50Y7sWd23zvOeV1HWgbN3Uan/j6UHfyWJrvqD
	KK9tUK8GgrZ2VY
From: Bernd Schubert <bernd-schubert@gmx.de>
To: Rene Herman <rene.herman@keyaccess.nl>
Subject: Re: x86: enable pat on amd athlon mode=6
Date: Wed, 25 Jun 2008 22:44:36 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <200806252153.35675.bernd-schubert@gmx.de> <4862A757.3020002@keyaccess.nl> <4862A8A2.8050407@keyaccess.nl>
In-Reply-To: <4862A8A2.8050407@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806252244.36840.bernd-schubert@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5600000000000001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 June 2008, Rene Herman wrote:
> On 25-06-08 22:15, Rene Herman wrote:
> > On 25-06-08 21:53, Bernd Schubert wrote:
> >> on my AthlonXP 1700 PAT works fine (I tested it several days). Please
> >> accept one of the patches below, I don't know which you refer.
> >>
> >> Signed-off-by: Bernd Schubert <bernd-schubert@gmx.de>
> >
> > Yes, PAT works equally well on my earlier model 6. The setup's already
> > changed in linux-next though and now blacklists some Intel models only:
> >
> > http://git.kernel.org/?p=linux/kernel/git/sfr/linux-next.git;a=blob;f=arc
> >h/x86/kernel/cpu/addon_cpuid_features.c;h=84a8220a6072c0425b9da95fbb28b5a3
> >09cbfda1;hb=HEAD
>
> Well, if I provide a link, I might as well look at it myself I guess...
>
> Earlier patches on linux-kernel did the white->black list switching but
> as you can see that in linux-next at least all of AMD is already
> whitelisted.

Great, thanks!


Cheers,
Bernd
