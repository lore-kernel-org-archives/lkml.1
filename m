Return-Path: <linux-kernel-owner+w=401wt.eu-S1753646AbZJAW2M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646AbZJAW2M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 18:28:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753481AbZJAW2M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 18:28:12 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:41776 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753396AbZJAW2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 18:28:11 -0400
Subject: Re: 2.6.32-rc0-git: oops in wireless, iwl3945 related?
From: Johannes Berg <johannes@sipsolutions.net>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-kernel@vger.kernel.org, yi.zhu@intel.com, reinette.chatre@intel.com,
       linux-wireless@vger.kernel.org
In-Reply-To: <20091001222413.GB10893@elf.ucw.cz>
References: <20090929171249.GB14405@elf.ucw.cz>
	 <1254431783.3959.45.camel@johannes.local>
	 <20091001222413.GB10893@elf.ucw.cz>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-mFFMDVuZEQo7rbj6aU18"
Date: Fri, 02 Oct 2009 00:28:13 +0200
Message-Id: <1254436093.3959.47.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-mFFMDVuZEQo7rbj6aU18
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-10-02 at 00:24 +0200, Pavel Machek wrote:

> Not sure. I was trying to setup adhoc network, randomly running
> scripts and pushing interfaces up and down. But I do have timestamps:
>=20
> Drat. What is going on? I guess this is from another instance; looks
> like I did not even notice it. text: address is same so that should be
> same version...?

> Sep 28 22:09:02 amd kernel: Registered led device: iwl-phy0::radio
> Sep 28 22:09:02 amd kernel: Registered led device: iwl-phy0::assoc
> Sep 28 22:09:02 amd kernel: Registered led device: iwl-phy0::RX
> Sep 28 22:09:02 amd kernel: Registered led device: iwl-phy0::TX
> Sep 28 22:09:02 amd wpa_supplicant[1984]: No network configuration
> found for the current AP
> Sep 28 22:09:11 amd wpa_supplicant[1984]: CTRL-EVENT-SCAN-RESULTS=20
> Sep 28 22:09:11 amd wpa_supplicant[1984]: No network configuration
> found for the current AP
> Sep 28 22:09:11 amd kernel: skb_over_panic: text:c07b4113 len:130
> put:36 head:e4c3edf0 data:e4c3edf0 tail:0xe4c3ee72 end:0xe4c3ee70
> dev:<NULL>

oddly, this one doesn't even have any of the other messages that we had
before the problem in the other instance.

johannes

--=-mFFMDVuZEQo7rbj6aU18
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKxSz5AAoJEODzc/N7+QmaYpYQAJoYLQpGHJjhexrQVvVq8jwO
cy+ctfj0RiCr23mzV97Az83HrTH/3uak/aG/ut9AVn4jwo/+ii2LXE3tVl7OlUgG
xAUTFr8JrzEPFyssWzTENqASa7cixsSbvsAkyJZYVRbB1WduEvTDgs/31+CYxxmu
BiOzIMponOP0sK4zGniimPdyTnIKxch3Dg3NHnVTJ2Nne/jj3kyRsV5sdYlP8RpA
qVUcWQXk4e5K7nT/W3l1MRfX/EbmWVOYpTz3sY/2y16DbqCmf1C7xfVRgi0jsdoi
+cAzVGesIYNH2+yaxkcXv5eanYF3m/ul+ADAS1d1vY8fynByppS09RBY2egslpn2
bdF2A35YOmCgoToRrcR5E1GJBgCiSGhvGdWu+QETocGPGAWMFDi6rF8BDOwWzfkm
JgQ+vUozDBGNbMyOjvF/KMLNDyMRsF5ga6q1oQA5lHEC4q9JT66PKAnmeXQuI0fR
a5SUsztPfZ0popGB4HVQmOW9Qx5S8VLMgwWYeGXsuf+R1KxjnC6aFZgYQmdDp5Pg
gTX34qN1PiqvE2bv3alIP/VNN8YKRBHhFniq9euHatyKxCtiNfRaNSb1lOLL7C1y
esxI/JF5DJbmg3cQ1nJTuFxRbaPGt6oxwDMeYh7gaMEPXya1YWLx0XxMSwKt18Qb
wHmZNIxrrcg3PO9QdIuN
=d1Na
-----END PGP SIGNATURE-----

--=-mFFMDVuZEQo7rbj6aU18--

