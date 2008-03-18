Return-Path: <linux-kernel-owner+w=401wt.eu-S1765104AbYCTAsh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765104AbYCTAsh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 20:48:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753147AbYCTAsU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 20:48:20 -0400
Received: from smtp-out5.blueyonder.co.uk ([195.188.213.8]:44885 "EHLO
	smtp-out5.blueyonder.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753119AbYCTAsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 20:48:18 -0400
X-Greylist: delayed 2848 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Mar 2008 20:48:18 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws; d=mattstone.net; h=date:from:to:
	subject:message-id:mime-version:content-type; q=dns; s=selector1; b=
	G3pNxMZSijBKijPlbUq3iWgPZPSMQQ+TD4w4fOVJRnnI4YBE9CQ81XIYnKbuEbMo
	eWf3UR4C7kfaotaxk27MoCbWl7LD3rg5RWHqlBjOjqtOMvTdWUO+Zj4doOFAmfTH
	X1DsYBcxCJjNcXWIGAjgqFEVQycbCUjreDV8G3rflb0=
Date: Tue, 18 Mar 2008 21:43:56 +0000
From: Matt Richards <matt@mattstone.net>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: RFC2644 (Enable Directed Broadcasts option)
Message-ID: <20080318214355.GA13933@mattstone.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gKMricLos+KVdGMg"
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gKMricLos+KVdGMg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,=20

Is it possible in the 2.6 kernels to enable linux routers to forward
directed broadcasts to the locally connected network?

The broadcast packet is routed OK until it hits the router that is
directly connected to the broadcast domain the packet is addresses to
and then it just appears to get dropped.

I have been reading that there isn't an option to enable these packets
to be forwarded or 'exploded' onto the correct network, if this is the
case is there anyway that I can make this work ?

Thanks for any feedback,

Matt.


--gKMricLos+KVdGMg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFH4DebrmnybSDmzlsRAkYpAKCOtWmzPz/LuLjo4Kg2oaJmqhTQjQCePzcS
2kTSEa0kG9d6hqfYweWT4JI=
=p8sI
-----END PGP SIGNATURE-----

--gKMricLos+KVdGMg--

