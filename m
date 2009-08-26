Return-Path: <linux-kernel-owner+w=401wt.eu-S1757340AbZHZKnu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757340AbZHZKnu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 06:43:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757148AbZHZKns
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 06:43:48 -0400
Received: from webmail.codefoundry.com ([62.231.42.10]:51407 "EHLO
	webmail.codefoundry.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757038AbZHZKnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 06:43:47 -0400
X-Greylist: delayed 302 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Aug 2009 06:43:46 EDT
Date: Wed, 26 Aug 2009 12:32:25 +0200
From: Michelle Konzack <linux4michelle@tamay-dogan.net>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: ARM Git Tree (at91sam9g45 patches)
Message-ID: <20090826103225.GB29500@tamay-dogan.net>
References: <9f53b4330908251727q1bc1accfk12a9a8d25407791@mail.gmail.com> <4A9488FB.60603@eukrea.com> <4A94FDDD.205@atmel.com> <4A95043C.9040807@atmel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_samba3-15121-1251283111-0001-2"
Content-Disposition: inline
In-Reply-To: <4A95043C.9040807@atmel.com>
X-Message-Flag: Improper configuration of Outlook is a breeding ground for
	viruses. Please take care your Client is configured correctly.
	Greetings Michelle.
X-Disclaimer-DE: Eine weitere Verwendung oder die Veroeffentlichung dieser
	Mail oder dieser Mailadresse ist nur mit der Einwilligung des
	Autors gestattet.
Organization: Tamay Dogan Network
X-Operating-System: Linux michelle1 2.6.26-1-686
X-Uptime: 12:29:36 up 53 days, 14:00, 12 users,  load average: 0.42, 0.91,
	0.94
X-Homepage: http://devel.debian.tamay-dogan.net/
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_samba3-15121-1251283111-0001-2
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Nicolas,

I have recently bought from DigiKey the AT91SAM9G45 Evaluation  Kit  and
would like to sa thanks for the Patch...

I have the hell here to get it running...

Note:  My own codes stuff (not running Linux) is working perfectly.
       (I am coding mostly in ASM)

Thanks, Greetings and nice Day/Evening
    Michelle Konzack
    Electronic Engineer
    Tamay Dogan Network
    Debian GNU/Linux Consultant


Am 2009-08-26 11:45:32, schrieb Nicolas Ferre:
> Hi all,
>=20
> I respond to myself...
>=20
> Nicolas Ferre :
> > Eric B=E9nard :
> >> Hi Robert,
> >>
> >> Robert Emanuele wrote :
> >>> I'm working with the Atmel at91sam9g45-ekes board which is new.  I was
> >>> wondering if there was a git tree with the current ARM patches that
> >>> contains the at91sam9g45 code?  Russell lists "Applied" patches at
> >>> http://www.arm.linux.org.uk/developer/patches/ .  Where are these
> >>> applied to?  If there isn't a tree, is there an elegant way to get the
> >>> latest patch sets that I could apply to Linus's tree?
> >>>
> >> you will find the files that you can apply using git am here :
> >> ftp://ftp.arm.linux.org.uk/pub/armlinux/kernel/git-cur/
> >=20
> > Yes, devel branch contains 9g45 patches.
> >=20
> > Another place where you can find quite all drivers that I submitted
> > during the past weeks is in the linux-next tree:
> >=20
> > http://git.kernel.org/?p=3Dlinux/kernel/git/next/linux-next.git;a=3Dsum=
mary
> >=20
> > FYI, I am building a patchset collecting all those submitted patches
> > against 2.6.30 + Andrew Victor -at91 patch.
> > It is not finished at the moment but I can send it in private.
>=20
> In fact I baked an archive that stores a snapshot of my work:
> ftp://www.linux4sam.org/devel/linux/2630_lnx4sam_patchset-tmp_20090826.tgz
>=20
> It is against vanilla 2.6.30
> + -at91 patch (from: http://maxim.org.za/at91_26.html of course)
>=20
> Regards,
> --=20
> Nicolas Ferre
>=20
>=20
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>=20
------------------------ END OF REPLIED MESSAGE ------------------------




--=20
Linux-User #280138 with the Linux Counter, http://counter.li.org/
##################### Debian GNU/Linux Consultant #####################
<http://www.tamay-dogan.net/>                 Michelle Konzack
<http://www.can4linux.org/>                   Apt. 917
<http://www.flexray4linux.org/>               50, rue de Soultz
Jabber linux4michelle@jabber.ccc.de           67100 Strabourg/France
IRC    #Debian (irc.icq.com)                  Tel. DE: +49 177 9351947
ICQ    #328449886                             Tel. FR: +33  6  61925193

--=_samba3-15121-1251283111-0001-2
Content-Type: application/pgp-signature; name="signature.pgp"
Content-Transfer-Encoding: 7bit
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQFKlQ85C0FPBMSS+BIRAsXVAJ0XZn4Y7MN9Axn74gs/nOpklU2bUwCfc6BP
8BZUuWacWnSnEq03B/8Wf8s=
=iLB/
-----END PGP SIGNATURE-----

--=_samba3-15121-1251283111-0001-2--
