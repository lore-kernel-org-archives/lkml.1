Return-Path: <linux-kernel-owner+w=401wt.eu-S1755983AbYJVSpW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755983AbYJVSpW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 14:45:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752364AbYJVSpI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 14:45:08 -0400
Received: from mo-p05-ob.rzone.de ([81.169.146.180]:23652 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545AbYJVSpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 14:45:07 -0400
X-RZG-CLASS-ID: mo05
X-RZG-AUTH: :Pm0FVUW6aauhRGJJc5OfA4AU8DM8ZlijdmJYxKn/UQvEQQx8Ak89p3I=
Date: Wed, 22 Oct 2008 20:45:04 +0200
From: Alex Riesen <raa.lkml@gmail.com>
To: Markus Rechberger <mrechberger@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       em28xx@mcentral.de,
       Linux and Kernel Video <video4linux-list@redhat.com>
Subject: Re: [PATCH] em28xx patches against the latest git tree
Message-ID: <20081022184504.GC4626@blimp.localdomain>
Reply-To: Alex Riesen <raa.lkml@gmail.com>
References: <d9def9db0810221034v3bf4dabt6aa905b8a3ebd5a@mail.gmail.com> <d9def9db0810221038g156871e1u200abb90b774ad28@mail.gmail.com> <81b0412b0810221059w2e02b1c1ubd894b22f7991242@mail.gmail.com> <d9def9db0810221110g6f104b17g36a74704d43c5693@mail.gmail.com> <20081022182924.GA4626@blimp.localdomain> <d9def9db0810221139w12ba033g360292d9624a1f91@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d9def9db0810221139w12ba033g360292d9624a1f91@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Markus Rechberger, Wed, Oct 22, 2008 20:39:51 +0200:
> >> Some patches got ported from my repository into the kernel although
> >> most devices don't work at all with the current inkernel driver (eg.
> >> em2888, flash based, isdb-t, cx25843, some saa7114.. based devices).
> >
> > Mine (a Pinnacle-Apple-something, USB) does not work with it at all.
> >
> 
> There's one limitation I cut out the drx3975d (might re-add it
> within the next week to the git repository) I know this one is
> required for the Pinnacle 330e and an Hauppauge based device.
> 
> If you have problems with your device please start a thread on the em28xx ML:
> http://mcentral.de/pipermail/em28xx/
> 

Ok, as soon as I get my hands on that card again.

