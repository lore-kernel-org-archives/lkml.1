Return-Path: <linux-kernel-owner+w=401wt.eu-S1756956AbYLDAWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756956AbYLDAWV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 19:22:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753126AbYLDAWM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 19:22:12 -0500
Received: from yw-out-2324.google.com ([74.125.46.30]:34453 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754236AbYLDAWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 19:22:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Iu6pM3cTKgLHPG/hQfYx4sktmL04MGPZXvrG1XGDRwQaekFKm0yKnsb1U4l3CQiaCg
         TcWdpPJs+J/MViGyRtaxkU2f7dyHiEtqR7BlFT7ljKdunNB9k1Y7mZkRaHqJa5K5SNk6
         lbBBWpZoz99jEpBv0peq4Jre210JwCBAawug8=
Message-ID: <804dabb00812031622j45fbdc76u5832a469a8a1d82c@mail.gmail.com>
Date: Thu, 4 Dec 2008 08:22:09 +0800
From: "Peter Teoh" <htmldeveloper@gmail.com>
To: "Geoffrey McRae" <geoff@rabidhost.com>
Subject: Re: New Security Features, Please Comment
Cc: "Miquel van Smoorenburg" <miquels@cistron.nl>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Nick Andrew" <nick@nick-andrew.net>, linux-kernel@vger.kernel.org
In-Reply-To: <1228348854.6993.38.camel@lappy.spacevs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1228260494.24232.21.camel@compy.ivent.com.au>
	 <20081203005338.6472db7a@lxorguk.ukuu.org.uk>
	 <1228268657.6679.4.camel@lappy.spacevs.com>
	 <20081203124252.GD11807@mail.local.tull.net>
	 <1228344292.6993.27.camel@lappy.spacevs.com>
	 <20081203230820.4473a162@lxorguk.ukuu.org.uk>
	 <1228347564.10407.18.camel@localhost.localdomain>
	 <1228348854.6993.38.camel@lappy.spacevs.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 4, 2008 at 8:00 AM, Geoffrey McRae <geoff@rabidhost.com> wrote:
>
> The setuid/gid concept in linux is very limited, it would be nice to be
> able to grant programs limited use of setuid, and even go one step
> further, grant programs limited ability to set child uids.

Yes, there can be many other variation on what u have just said, eg,
adding conditions whereby the grant can be used, etc.   If u have a
chance to learn a little bit of SELinux, u will know the whole thing
can be very complex, especially the rules and policies configuration.
 It is a fine balance between overheads vs performance and usability.

>
> To be completly honest, this is the kind of functionallity I expected to
> already be there, and I was hopeing someone would tell me to RTFM on
> function X that already does this...
>

Yes, I am sure it exists...and more likely than not, it can be very
application specific, and therefore, will be done by the higher-end
application in userspace.

But looking beyond, is there any other OS that may have something
similar?  (Windows, or OpenBSD etc?)   Not sure for me.

-- 
Regards,
Peter Teoh

Ernest Hemingway - "Never mistake motion for action."
