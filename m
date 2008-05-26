Return-Path: <linux-kernel-owner+w=401wt.eu-S1756305AbYEZSnt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756305AbYEZSnt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 14:43:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754632AbYEZSnl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 14:43:41 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:27628 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754059AbYEZSnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 14:43:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=CbEyDdYOifP9dQhn20phIV4nHi5Mds+HUZ7wKO5kCxh9eLzIbyv0aa1fflp/04cLoUPVfoNlTorucFaVZeCOh4kTVcQvSs4WWltJyymyLgW/2vZ8HAN5cYXR3kc6KZqw8Imqt2PvAcLJHnm1CgPzky/82GN05CH883yVG1Xn6Bw=
Date: Mon, 26 May 2008 15:46:54 -0300
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Justin Madru <jdm64@gawab.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: Oops in mac80211 with 2.6.26-rc3 triggered playing a video
Message-ID: <20080526184654.GA5651@Pilar.ictp.trieste.it>
References: <483A3F91.6020403@gawab.com> <19f34abd0805260049j621c882r970444b65e384355@mail.gmail.com> <483AECEF.9030509@gawab.com> <19f34abd0805261052v38345716i3e6837ebe5d4a710@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0805261052v38345716i3e6837ebe5d4a710@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
> PS: Some similar oops decoding was previously demonstrated on LKML
> (Rusty Russell? I don't remember.). I couldn't find it with Google,
> but maybe somebody else can give a pointer?

Heh, I did some more research and found this example by Linus himself:

http://lkml.org/lkml/2008/1/7/406

