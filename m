Return-Path: <linux-kernel-owner+w=401wt.eu-S1946608AbXBQH0J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946608AbXBQH0J (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 02:26:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946609AbXBQH0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 02:26:09 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:51717 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946608AbXBQH0I (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 02:26:08 -0500
Message-Id: <200702170726.l1H7Q1iJ026705@turing-police.cc.vt.edu>
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Alexandre Oliva <aoliva@redhat.com>
Cc: davids@webmaster.com, jas6180@gmail.com,
       "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: GPL vs non-GPL device drivers
In-Reply-To: Your message of "Sat, 17 Feb 2007 04:44:36 -0200."
             <orejops2p7.fsf@free.oliva.athome.lsd.ic.unicamp.br>
From: Valdis.Kletnieks@vt.edu
References: <MDEHLPKNGKAHNMBLJOLKMEIMBKAC.davids@webmaster.com>
            <orejops2p7.fsf@free.oliva.athome.lsd.ic.unicamp.br>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1171697161_4862P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sat, 17 Feb 2007 02:26:01 -0500
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1171697161_4862P
Content-Type: text/plain; charset=us-ascii

On Sat, 17 Feb 2007 04:44:36 -0200, Alexandre Oliva said:
> On Feb 17, 2007, "David Schwartz" <davids@webmaster.com> wrote:
> > Not so. See any of the numerous cases that explain that you cannot own a
> > function using copyright. They are saying that because V J did X, he *MUST*
> > be taking their code because there is no other practical way to *do* X. This
> > is precisely what copyright *DOES* *NOT* *LET* *YOU* *DO*.
> 
> So, since there's no other way to do Yesterday, exactly as performed
> by the Beatles in the 1965 album Help!, I'm free to copy it, perform
> it, create derived versions thereof and perform them, without paying
> royalties to the current copyright holders?

No, because there's other musically valid ways to perform the song - in the
style of Wayne Newton, or the band Slipknot, or restyled as a Bach cantata.

(Incidentally - in the case of the song Yesterday, there are *two* different
performance rights to consider.  The right to play the version that's on the
album Help!, which (usually) means you (as a radio station, or background-music
vendor, or DJ at a party, etc) need to pay royalties to somebody (usually the
record label), via ASCAP or BMI (two large payment clearinghouses - usually a
radio station or DJ just pays a lump-sum per month/year and ASCAP and BMI sort
it out).  Then there's the *music* copyright, which means that Wayne Newton's
manager gets to negotiate with the group that administers the copyright on
the song *itself* for how much it will cost Wayne to record his version.  Then
the record label gets to screw Wayne out of his share of the money that ASCAP
and BMI sends the label, but that's another rant.. ;)

But trying to call a kernel function in any other way than the one intended
by the function's author *isn't* valid - it may not even compile, if the
function's parameter list is formally incorrect, or it will likely OOPS
(perhaps later, after a stray pointer does a fandango on core).  And since
there *is* only one valid way to call (for instance) kzalloc(), it becomes
a 'scenes au faire', which is what the Lexmark ruling was about.

--==_Exmh_1171697161_4862P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFF1q4JcC3lWbTT17ARAqvGAKCiqXnAHufiRF77nOljr9nyQktkEgCdG3ya
Lx91GXONJ/MfFxwzz9mXKJw=
=/1vh
-----END PGP SIGNATURE-----

--==_Exmh_1171697161_4862P--
