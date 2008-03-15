Return-Path: <linux-kernel-owner+w=401wt.eu-S1752796AbYCOCg4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796AbYCOCg4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 22:36:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751131AbYCOCgq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 22:36:46 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38536 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751420AbYCOCgp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 22:36:45 -0400
From: Jarod Wilson <jwilson@redhat.com>
Organization: Red Hat, Inc.
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH update] firewire: debug AT, AR, and selfID-complete events
Date: Fri, 14 Mar 2008 21:57:42 -0400
User-Agent: KMail/1.9.9
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <tkrat.f96c4067f6a48f4a@s5r6.in-berlin.de> <200803121034.39583.jwilson@redhat.com> <47D7FE4D.5090107@s5r6.in-berlin.de>
In-Reply-To: <47D7FE4D.5090107@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803142157.42684.jwilson@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 March 2008 12:01:17 pm Stefan Richter wrote:
> Jarod Wilson wrote:
> > Want to do that as a later follow-up patch, or roll it into this one and
> > post another update?
>
> I haven't committed to linux1394-2.6.git, hence I prefer to post an
> update rather than incremental patch.
>
> > (I'm fully prepared to sign off on either way after having
> > extensively used these patches the past several days...)
>
> BTW, if I get sign-offs/ acks/ test feedback on a patch before another
> patch update (but not before committing the final version to the
> upstream submission branch), I add those sign-offs etc. like this
>
>     S-o-b: Someone
>     S-o-b: Me (modified whitespace or something else trivial)
>
> or this
>
>     Initial changelog
>
>     S-o-b: Someone
>
>     Changelog post scriptum
>
>     S-o-b: Me
>
> provided that the update only marginally changes the patch or can be
> clearly distinguished from the formerly signed off parts.  Of course if
> I get sign-offs etc. on the final version of the patch

In that case, for the version with module params to enable debugging:

Signed-off-by: Jarod Wilson <jwilson@redhat.com>


-- 
Jarod Wilson
jwilson@redhat.com
