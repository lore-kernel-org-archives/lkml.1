Return-Path: <linux-kernel-owner+w=401wt.eu-S1761676AbXFAOho@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761676AbXFAOho (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 10:37:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759624AbXFAOhh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 10:37:37 -0400
Received: from smtp01.cdmon.com ([86.109.99.230]:58889 "EHLO smtp01.cdmon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758803AbXFAOhh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 10:37:37 -0400
Date: Fri, 1 Jun 2007 16:39:40 +0200
From: DervishD <lkml@dervishd.net>
To: CaT <cat@zip.com.au>
Cc: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Kernel utf-8 handling
Message-ID: <20070601143940.GA3103@DervishD>
Mail-Followup-To: CaT <cat@zip.com.au>,
	Linux-kernel <linux-kernel@vger.kernel.org>
References: <20070601142058.GA2587@DervishD> <20070601143055.GD3807@zip.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070601143055.GD3807@zip.com.au>
User-Agent: Mutt/1.4.2.3i
Organization: DervishD
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

    Hi CaT :)

 * CaT <cat@zip.com.au> dixit:
> On Fri, Jun 01, 2007 at 04:20:58PM +0200, DervishD wrote:
> >     This said, I know that the console will give me no problems
> > regarding character representantion (heck, I'm pretty sure that I will
> > be able to use even the same font I'm using right now in the console if
> > I get the proper unicode map), but probably will give me problems when
> > *entering* characters. I've read that the kernel handles accented chars,
> > and things like '?' (ntilde) because it assumes that any composed
> > character (composed using dead keys, for example) is in the latin1
> > range. While this is not a perfect behaviour, it will work for me.
> 
> Hmmm. I've not yet played with moving to utf-8 but would
> 
> man console_codes
> 
> be of help to you?

    Not, because I already know the escape sequence to go back and forth
to utf-8 mode O:)) I'm going to carry some tests using Ubuntu, but since
that is a distro I'm not sure if I will be able to apply the same
solutions and mechanisms to my do-it-yourself box.

    Thanks anyway for answering :)

    Raúl Núñez de Arenas Coronado

-- 
Linux Registered User 88736 | http://www.dervishd.net
It's my PC and I'll cry if I want to... RAmen!
