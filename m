Return-Path: <linux-kernel-owner+w=401wt.eu-S1755566AbZLDBtO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755566AbZLDBtO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 20:49:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755472AbZLDBtM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 20:49:12 -0500
Received: from mail-gx0-f226.google.com ([209.85.217.226]:33121 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754846AbZLDBtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 20:49:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=q24Ukjk/ZzCgzpbDWPptRGv3nSTbWCBwKkwvdDxteEPQIhX7tT+vuiOy89dIjgmFsE
         ChdPf/6GNlTjwFGRipJ3bkamNmG8OU44uv3ulVbSRSF7Xlisuphf60EYX6weno8DhkG6
         r8coGCBnYvEylmH4wQAqsMRPCE64hmImCSmcw=
MIME-Version: 1.0
In-Reply-To: <20091127224206.GA3350@ami.dom.local>
References: <81bfc67a0911232217n41b9ac02w3b7770b789e5d209@mail.gmail.com>
	 <20091124111946.GA7883@ff.dom.local>
	 <81bfc67a0911250606k1ec76354n217da9ca20b3517c@mail.gmail.com>
	 <20091125191105.GA3167@ami.dom.local>
	 <81bfc67a0911271007o1fb8f8c2vdd36e8585280e4da@mail.gmail.com>
	 <20091127213640.GA2611@ami.dom.local>
	 <81bfc67a0911271435g4106652bpe8c9ea07893d0ebd@mail.gmail.com>
	 <20091127224206.GA3350@ami.dom.local>
Date: Thu, 3 Dec 2009 20:49:17 -0500
Message-ID: <81bfc67a0912031749y15faed66s9c8a924684c97a19@mail.gmail.com>
Subject: Re: large packet loss take2 2.6.31.x
From: Caleb Cushing <xenoterracide@gmail.com>
To: Jarek Poplawski <jarkao2@gmail.com>
Cc: Frans Pop <elendil@planet.nl>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       e1000-devel@lists.sourceforge.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> modprobe -r e1000e
> modprobe e1000e IntMode=0
>
> Jarek P.
>
tested on kernel behaving properly no change. what do these modes do?

I've installed a 10/100 linksys nic into my system. it appears to be
working fine on a bad kernel (2.6.32-final tested and for sure
verified). I've only tested it once though. my laptop died so direct
connection between that won't work. can I test between these 2 nics?
(suppose no real reason why not) but what should I proceed with at
this point?


-- 
Caleb Cushing

http://xenoterracide.blogspot.com
