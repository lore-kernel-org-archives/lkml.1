Return-Path: <linux-kernel-owner+w=401wt.eu-S1754024AbZKQQtL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024AbZKQQtL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 11:49:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752580AbZKQQtK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 11:49:10 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:55864 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751839AbZKQQtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 11:49:10 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: lsorense@csclub.uwaterloo.ca (Lennart Sorensen),
       Pavel Machek <pavel@ucw.cz>, "H. Peter Anvin" <hpa@zytor.com>,
       Matteo Croce <technoboy85@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: i686 quirk for AMD Geode
In-Reply-To: Your message of "Tue, 17 Nov 2009 11:59:29 GMT."
             <20091117115929.4ba23c49@lxorguk.ukuu.org.uk>
From: Valdis.Kletnieks@vt.edu
References: <4AF4526B.4060101@zytor.com> <40101cc30911081042n93e268bs66b9436a0174a19a@mail.gmail.com> <20091109201608.GD15159@caffeine.csclub.uwaterloo.ca> <4AF886D4.1080108@zytor.com> <20091109212333.GE15159@caffeine.csclub.uwaterloo.ca> <20091112121805.GF1394@ucw.cz> <20091113162301.GU15157@caffeine.csclub.uwaterloo.ca> <20091113165730.0b9b2676@lxorguk.ukuu.org.uk> <20091113192412.GY15157@caffeine.csclub.uwaterloo.ca> <20091113212148.5cb829d4@lxorguk.ukuu.org.uk> <20091116175006.GA15157@caffeine.csclub.uwaterloo.ca>
            <20091117115929.4ba23c49@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1258476526_3145P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 17 Nov 2009 11:48:47 -0500
Message-ID: <7332.1258476527@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 128.173.14.107 turing-police.cc.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (0) 
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020203.4B02D3EF.009F,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1258476526_3145P
Content-Type: text/plain; charset=us-ascii

On Tue, 17 Nov 2009 11:59:29 GMT, Alan Cox said:
> > Trying rdmsr from msr-tools 1.2 gives me:
> > 
> > # ./rdmsr -x 0x00001810
> > rdmsr: CPU 0 cannot read MSR 0x00001810
> > 
> > Hmm, now what?
> 
> Beats me - I thought the region registers were read/write.

Umm...  'modprobe msr'?

(Recently I had what *looked* like an xorg server bug, turned out to be a
missing CONFIG_INPUT_EVDEV.. Whoops. ;)


--==_Exmh_1258476526_3145P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFLAtPucC3lWbTT17ARAlyeAJ9ZV2hV0r6Jp1hjUtiAm/ZVa+EgEgCggf+P
C2uab9C39cVQqnHPp6REq1I=
=ePxo
-----END PGP SIGNATURE-----

--==_Exmh_1258476526_3145P--

