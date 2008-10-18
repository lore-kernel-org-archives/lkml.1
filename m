Return-Path: <linux-kernel-owner+w=401wt.eu-S1752587AbYJRGpQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752587AbYJRGpQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 02:45:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751212AbYJRGpD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 02:45:03 -0400
Received: from wx-out-0506.google.com ([66.249.82.234]:37171 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994AbYJRGpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 02:45:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:cc:subject:references
         :in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding:from;
        b=EufPQ/gpOBDzZvFbLJJX+w6l8l8vHbDxxYFvAj7NFl4stliKRv3JAO/F15UM7kWBNN
         S8M2FfrEBL65X1xLNVVCq6q/EU6LLBjNnWmfLFkKrxFcPa5k8kIoI9x1KviQ1bEBxAas
         9hcfFz6K/pUyhh6m9YYudBCwKEKJw1cftI8qE=
Message-ID: <48F985E7.7050302@gmail.com>
Date: Fri, 17 Oct 2008 23:44:55 -0700
User-Agent: Thunderbird 2.0.0.17 (X11/20081009)
MIME-Version: 1.0
To: Keith Packard <keithp@keithp.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Dave Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git pull] drm patches for 2.6.27-rc1
References: <alpine.DEB.0.82.0810172227490.14817@skynet.skynet.ie>	<alpine.LFD.2.00.0810171510170.3438@nehalem.linux-foundation.org>	<1224295858.4378.8.camel@vonnegut.anholt.net>	<alpine.LFD.2.00.0810171941120.3438@nehalem.linux-foundation.org> <1224301790.4384.38.camel@koto.keithp.com>
In-Reply-To: <1224301790.4384.38.camel@koto.keithp.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
From: Corbin Simpson <mostawesomedude@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Keith Packard wrote:
> On Fri, 2008-10-17 at 19:47 -0700, Linus Torvalds wrote:
> 
>> Really? None of you use any modern CPU's, or you're _all_ running 32-bit 
>> distros even though your cpu's could support 64-bit ones?
> 
> We're lazy, perhaps even lazier than yourself. Given that the whole goal
> is to essentially ignore the CPU and get our code running on the GPU,
> it's hard to get excited about the kind of kernel we're running on the
> CPU.
> 
> We've got a bunch of test boxes that run 64-bits, unfortunately, the
> people doing builds there appear not to care about warnings. That will
> get fixed.

Indeed. I have been running 64 bit builds for quite a while now, and
merely ignored the warnings as "not my problem." In the future, I shall
make it my problem.

~ C.

- --
~ Corbin Simpson
<MostAwesomeDude@gmail.com>
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkj5hecACgkQeCCY8PC5utAMAQCggtkBoolO58rW5PnPkYTosyZ5
DkgAnAqRSZzoFhgkdFcL92qV6Zyc7usJ
=vpMP
-----END PGP SIGNATURE-----
