Return-Path: <linux-kernel-owner+w=401wt.eu-S1759225AbYFQNxl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759225AbYFQNxl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 09:53:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757715AbYFQNxa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 09:53:30 -0400
Received: from daemonizer.de ([87.230.16.230]:55421 "EHLO daemonizer.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757908AbYFQNxa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 09:53:30 -0400
From: Maximilian Engelhardt <maxi@daemonizer.de>
To: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [regression] display dimming is slow and laggy
Date: Tue, 17 Jun 2008 15:53:08 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel <linux-kernel@vger.kernel.org>
References: <fa.bYtHs6zUqCWUnOriVTRy2wrCy7s@ifi.uio.no> <485702F7.6060704@shaw.ca>
In-Reply-To: <485702F7.6060704@shaw.ca>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart5236580.YPOyJHK690";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200806171553.12880.maxi@daemonizer.de>
X-Spam-Score: -4.2 (----)
X-Spam-Report: No, hits=-4.2 required=5.0 tests=ALL_TRUSTED,AWL,BAYES_00 autolearn=ham version=3.2.3 
	* -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	*  0.2 AWL AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart5236580.YPOyJHK690
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Tuesday 17 June 2008, Robert Hancock wrote:
> Maximilian Engelhardt wrote:
> > Hello,
> >
> > I'm using kernel 2.6.26-rc6 at the moment and with it dimming the displ=
ay
> > is slow and laggy. Using kernel 2.6.25 doesn't show this problem.
> >
> > Here is a more detailed explanation:
> >
> > I'm dimming my display with the appropriate keys on my laptop (Fn +
> > right/left). Till kernel 2.6.25 this has worked without any problems. N=
ow
> > I'm using 2.6.26-rc6 and using the keys the display is dimming much
> > slower and also laggy. By laggy I mean if I hit the keys for
> > increasing/decreasing brightness it starts dimming and when I release t=
he
> > keys after some time it still continues dimming for some steps.
> >
> > My laptop is a Acer Travelmate 661lci and has an Intel 855 chipset.
> >
> > I'll attach my dmesg output, please tell me if you need any further
> > information.
>
> Think you forgot the dmesg.
Hm, I'm quite sure I did attach it. Here it is again:

http://bugzilla.kernel.org/show_bug.cgi?id=3D10919

> Are you seeing a "ACPI: EC: GPE storm=20
> detected, disabling EC GPE" message? See:
>
> http://bugzilla.kernel.org/show_bug.cgi?id=3D10724

Yes, I see this message.

Maxi

--nextPart5236580.YPOyJHK690
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkhXwcUACgkQOimwv528XGGicQCfZhjyDgawb0+c1/qWyxnb2nwg
/NwAn1pyIxv/XEXxijJdJClDYmX7TXFI
=m6u3
-----END PGP SIGNATURE-----

--nextPart5236580.YPOyJHK690--
