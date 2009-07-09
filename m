Return-Path: <linux-kernel-owner+w=401wt.eu-S1754373AbZGIWYE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754373AbZGIWYE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 18:24:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751413AbZGIWXw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 18:23:52 -0400
Received: from mondschein.lichtvoll.de ([194.150.191.11]:33656 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903AbZGIWXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 18:23:51 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: David Newall <davidn@davidnewall.com>
Subject: Re: CONFIG_VFAT_FS_DUALNAMES regressions
Date: Fri, 10 Jul 2009 00:23:38 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.29.6-tp42-toi-3.0.1-00977-gf7efeea; KDE/4.2.4; i686; ; )
Cc: Christoph Hellwig <hch@infradead.org>, Theodore Tso <tytso@mit.edu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       tridge@samba.org, Jan Engelhardt <jengelh@medozas.de>,
       Rusty Russell <rusty@rustcorp.com.au>, Pavel Machek <pavel@ucw.cz>,
       john.lanza@linux.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, corbet@lwn.net,
       jcm@jonmasters.org
References: <20090708110451.1092afa7@lxorguk.ukuu.org.uk> <20090709171501.GA2991@infradead.org> <4A5659A0.2030202@davidnewall.com> (sfid-20090709_234303_323994_088E73F9)
In-Reply-To: <4A5659A0.2030202@davidnewall.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4480122.5GH1jPMVCK";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200907100023.48039.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart4480122.5GH1jPMVCK
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Am Donnerstag 09 Juli 2009 schrieb David Newall:
> Christoph Hellwig wrote:
> > If someone really wants a patch to corrupt their filesystems they
> > know where to find it.
>
> No need for pettiness. Andrew's already intimated that he's still
> working the patch, and he's a very clever lad and knows if it corrupts
> it needs more work.
>
> What I don't understand is how anybody could be satisfied with the
> status quo. We cannot leave vfat unchanged, for that will perpetuate a
> pool of victims to be sued, and Linux loses credibility every time that
> happens. Something *must* change.
>
> What is especially attractive about Andrew's position (he said this
> more eloquently than me) is that developing a solution to avoid the
> patent will impact Microsoft revenues; and that will be most
> instructive to them. That's almost sufficient reason by itself!

Pardon me, but I just don't get how adapting software to software patents=20
will contribute into solving the problems they cause. Instead of=20
implementing a feature like long name + short name support straight=20
forwardly and simply one has to invent utterly complex, error prone and=20
ugly work-arounds that actually even limit the functionality. Actually I=20
do not envy Tridge for doing that job.

To me it seems that Microsoft has won if it can get Linux kernel=20
developers to cripple the upstream vanilla kernel in order to avoid=20
software patents. If it can get Linux kernel developers to accept a patch=20
that if activated limits interoperatibility and compatibily with uncounted=
=20
implementations of the one and only widely spread multiplatform and=20
multidevice data exchange filesystem out there currently. If it can get=20
Linux kernel developers to accept a patch that if activated actually risks=
=20
more bugs and errors and thus makes the implementation less reliable than=20
before.

To me it seems challenging the FAT standard by a modern replacement would=20
still be the best way to go. Any hours wasted into a patch like=20
CONFIG_VFAT_FS_DUALNAMES IMHO should be better spent with thinking about=20
and implementing a replacement filesystem. Of course everyone is free to=20
spend their time as they wish, but thats my oppinion.

The legal action of Microsoft against TomTom seems to create fear,=20
uncertainity and doubts once again. And giving in to that IMHO would mean=20
that Microsoft had already (partly) won.

Microsoft sued only TomTom regarding FAT patents upto now. Why? If they=20
acted like SCO they would have gone against IBM, big Linux distributors=20
like Novell and especially against several companies at once. I think this=
=20
might be cause that Microsoft just knows that their software patent claim=20
would break down if really tested. I do think that Microsoft does not want=
=20
those FAT patents to be tested in court. Cause I think they know they=20
would not stand a chance.

Accepting such a patch IMHO would help Microsoft to get away with seeding=20
fear, uncertainity and doubt and not having the software patent tested and=
=20
be made void. Actively adapting to software patents gives them a place to=20
be, gives those who support them your energy.

Actually I think just ignoring them would be better. Don't give your=20
energy to software patents. Ignore them and only defend were attacked=20
unless the world sees how ridiculous they really are. TomTom can remove=20
long name FAT from the Linux kernels they use to defend themselves if they=
=20
can't stand the trial. This would be defending where necessary. Putting a=20
patch in upstream Linux kernel would just be overreacting. Microsoft did=20
not yet attack the upstream Linux kernel. And I think they won't. At least=
=20
when they act rational. Thus IMHO there is no need to even think about=20
adapting it.

And I think its not the job of the upstream kernel to protect companies=20
that can not stand a patent trial or do not like to stand it. Its open-
source. They can remove parts of it.

Shall Microsoft attack IBM or other big companies. Shall Microsoft attack=20
big Linux distributors. Shall they attack the upstream Linux kernel -=20
however, I can't imagine an easy way to do that. Shall they ruin their=20
image completely - the did quite well on that with Vista already. Don't=20
help them not doing that. If Microsoft lawyers so desire let them go and=20
make Microsoft a parody like lawyers of SCO managed to do.

=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

--nextPart4480122.5GH1jPMVCK
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkpWbewACgkQmRvqrKWZhMdLwQCfTXFhNzLuUjseKyl/AkOA+RXD
cu4AoJxkMF99o5blfuOZgws6js6CLtqU
=9Lhu
-----END PGP SIGNATURE-----

--nextPart4480122.5GH1jPMVCK--
