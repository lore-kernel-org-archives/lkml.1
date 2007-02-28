Return-Path: <linux-kernel-owner+w=401wt.eu-S1752109AbXB1KsN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752109AbXB1KsN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 05:48:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752110AbXB1KsN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 05:48:13 -0500
Received: from smtp01.cdmon.com ([86.109.99.230]:54782 "EHLO smtp01.cdmon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752109AbXB1KsN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 05:48:13 -0500
Date: Wed, 28 Feb 2007 11:49:36 +0100
From: DervishD <lkml@dervishd.net>
To: "Antonino A. Daplas" <adaplas@gmail.com>
Cc: Linux-kernel <linux-kernel@vger.kernel.org>,
       Linux Fbdev development list 
	<linux-fbdev-devel@lists.sourceforge.net>
Subject: Re: tdfx framebuffer garbles display in 2.6.19.5
Message-ID: <20070228104936.GA4523@DervishD>
Mail-Followup-To: "Antonino A. Daplas" <adaplas@gmail.com>,
	Linux-kernel <linux-kernel@vger.kernel.org>,
	Linux Fbdev development list <linux-fbdev-devel@lists.sourceforge.net>
References: <20070226144744.GA3615@DervishD> <1172503471.20842.14.camel@daplas> <20070226171334.GB13496@DervishD> <1172510654.7101.11.camel@daplas> <20070226203223.GA161@DervishD> <1172617755.13422.0.camel@daplas>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1172617755.13422.0.camel@daplas>
User-Agent: Mutt/1.4.2.2i
Organization: DervishD
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

    Hi Antonino :)

 * Antonino A. Daplas <adaplas@gmail.com> dixit:
> On Mon, 2007-02-26 at 21:32 +0100, DervishD wrote:
> >     Probably setting it back to 4096 will make the problem reappear.
> > Right now I cannot test, but I'll make some experiments.
> 
> Can you try this patch?  It might help with the screen corruption.

    I'm doing system maintenance now, and won't have spare time until
friday, probably, but as soon as possible I'll test the patch. Thanks a
lot for your invaluable help :)

    If you want me to test more patches, feel free. I'll test them ASAP,
probably this weekend if I can afford the time.

    Raúl Núñez de Arenas Coronado

-- 
Linux Registered User 88736 | http://www.dervishd.net
It's my PC and I'll cry if I want to... RAmen!
