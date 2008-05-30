Return-Path: <linux-kernel-owner+w=401wt.eu-S1760196AbYE3Fzu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760196AbYE3Fzu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 01:55:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754542AbYE3Fzn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 01:55:43 -0400
Received: from host-88-217-143-53.customer.m-online.net ([88.217.143.53]:35939
	"EHLO master.home" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754276AbYE3Fzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 01:55:42 -0400
X-Greylist: delayed 2074 seconds by postgrey-1.27 at vger.kernel.org; Fri, 30 May 2008 01:55:42 EDT
Date: Fri, 30 May 2008 07:20:49 +0200
From: Florian Attenberger <valdyn@valdyn.org>
To: Andres Freund <andres@anarazel.de>
Cc: linux-kernel@vger.kernel.org, perex@perex.cz, tiwai@suse.de,
       pshou@realtek.com.tw, Jeff Garzik <jgarzik@redhat.com>
Subject: Re: [BUG] Barely understandeable sound with snd_hda_intel and
 2.6.26-rc4
Message-Id: <20080530072049.e260432c.valdyn@valdyn.org>
In-Reply-To: <200805300004.16169.andres@anarazel.de>
References: <200805300004.16169.andres@anarazel.de>
X-Mailer: Sylpheed 2.5.0beta3 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__30_May_2008_07_20_49_+0200_iOPz7zhijGvy=KB0"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__30_May_2008_07_20_49_+0200_iOPz7zhijGvy=KB0
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

> CONFIG_SND_PCSP=3Dm

^^ is making your pc speaker your default sound device, i guess. Module
is 'snd_pcsp'.

--=20
Florian Attenberger <valdyn@valdyn.org>

--Signature=_Fri__30_May_2008_07_20_49_+0200_iOPz7zhijGvy=KB0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIP46/2VhSN8sRLIwRAg8tAKCXxP/WIlnVDfNXbsZa9Ha9biWiIgCdElT0
xaYu5rrwUK0hcjH0F3sc72g=
=sn+N
-----END PGP SIGNATURE-----

--Signature=_Fri__30_May_2008_07_20_49_+0200_iOPz7zhijGvy=KB0--
