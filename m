Return-Path: <linux-kernel-owner+w=401wt.eu-S1759404AbYD0GLh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759404AbYD0GLh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 02:11:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751594AbYD0GLa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 02:11:30 -0400
Received: from an-out-0708.google.com ([209.85.132.251]:63464 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812AbYD0GL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 02:11:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=H6jWZ16SXPa3cmbt7ffaXYSwA1UL3hkynA9PujQ2j4HMD7f33HR5f42U8eIkQH0citXcFukGiRFeGik+QE2hTiX5WErZgYaVq48SCwJgqd8MGwLMr0sTkFECdJxT3cSIGlssJXjKSRFZnVfEJQFPYLbNECh3z+56t6hHdZX4dgc=
Message-ID: <dd18b0c30804262311h64d9ed9aqa65b6ca22e65e546@mail.gmail.com>
Date: Sun, 27 Apr 2008 06:11:28 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Bob Copeland" <me@bobcopeland.com>
Subject: Re: spinlock lockup on CPU#0
Cc: "Bernard Pidoux" <bpidoux@free.fr>, linux-kernel@vger.kernel.org
In-Reply-To: <b6c5339f0804261941n1a25d37axe17c413fca481e18@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200804262333.39383.bpidoux@free.fr>
	 <200804270215.23739.bpidoux@free.fr>
	 <dd18b0c30804261900m1a2edebld6a796e1de85c19e@mail.gmail.com>
	 <b6c5339f0804261913l4e3b6aacsa1e9db120d8fed8b@mail.gmail.com>
	 <dd18b0c30804261920o3bd3c7c3ud5969981f5f7d18e@mail.gmail.com>
	 <b6c5339f0804261941n1a25d37axe17c413fca481e18@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 27, 2008 at 2:41 AM, Bob Copeland <me@bobcopeland.com> wrote:
> On Sat, Apr 26, 2008 at 10:20 PM, Justin Mattock
>  <justinmattock@gmail.com> wrote:
>  >
>  >  I'll have to give that a try, the number for my card is: AR5418
>  >  If there is'nt any support, then I'll have to use the ndiswrapper approach
>  >  for the time being as a quick solution, or revert to my backup kernel
>
>  Ah, I am using AR5006 which is a 5424, so ymmv.
>
>  --
>
>
> Bob Copeland %% www.bobcopeland.com
>

After thinking "Youremileagemayvery", sorry I'm a little slow;
I tried, ath5k gives a not supported flag. With this in mind I'm going
to spent a few hours looking at what I had until ath5k is supported
regards;

-- 
Justin P. Mattock
