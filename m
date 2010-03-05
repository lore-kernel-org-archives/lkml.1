Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755900Ab0CEXug (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 18:50:36 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:48782 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755328Ab0CEXue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 18:50:34 -0500
X-Sasl-enc: jI6Dk7qY0OrSQazqELQ82riXygUQicqoHUeAzjeBVYZt 1267833033
Message-ID: <4B9198C2.9080202@imap.cc>
Date: Sat, 06 Mar 2010 00:50:26 +0100
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; de; rv:1.9.1.8) Gecko/20100205 SeaMonkey/2.0.3
MIME-Version: 1.0
To: tytso@mit.edu, Corbin Simpson <mostawesomedude@gmail.com>,
       Daniel Stone <daniel@fooishbar.org>, David Miller <davem@davemloft.net>,
       skeggsb@gmail.com, airlied@linux.ie, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org, dri-devel@lists.sf.net, mingo@elte.hu,
       torvalds@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [git pull] drm request 3
References: <20100305151754.GB2505@tempa> <20100305.072612.186421758.davem@davemloft.net> <20100305154009.GC2505@tempa> <20100305.074835.159078083.davem@davemloft.net> <20100305160434.GE2505@tempa> <20100305164615.GC6000@thunk.org> <e7bd23c31003051138k14436b42t5bf544c375413c6c@mail.gmail.com> <20100305215106.GE6000@thunk.org>
In-Reply-To: <20100305215106.GE6000@thunk.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Am 2010-03-05 22:51 schrieb tytso@mit.edu:
> On Fri, Mar 05, 2010 at 11:38:46AM -0800, Corbin Simpson wrote:
>> If distros want to run weird experiments on their users, let them!
>> Sure, sometimes bad things happen, but sometimes good things happen
>> too. ConsoleKit, DeviceKit, HAL, NetworkManager, KMS, yaird, dracut,
>> Plymouth, the list goes on and on.
> 
> So what distro would you recommend for people who want to do kernel
> development, do kernel testing, and do kernel bisects to help us find
> bugs?
> 
> Are you basically saying, "Kernel people shouldn't use Fedora"?  So
> what should we use instead?

It's been "Kernel people shouldn't use Nvidia" ever since I started
tinkering with device drivers for Linux. Of course there's hope that
nouveau will one day change that, but we're obviously not quite there yet.

Jm2c
Tilman

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkuRmMIACgkQQ3+did9BuFvPcgCfesxRGK/XabLxAEY143aDYwdN
Z7EAnjAbZKyUutNfzl9enda05vJLSRDV
=e26J
-----END PGP SIGNATURE-----
