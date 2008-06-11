Return-Path: <linux-kernel-owner+w=401wt.eu-S1754106AbYFKLU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106AbYFKLU3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 07:20:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751963AbYFKLUR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 07:20:17 -0400
Received: from main.gmane.org ([80.91.229.2]:41066 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751234AbYFKLUQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 07:20:16 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Walter Franzini <walter.franzini@gmail.com>
Subject: Re: Oops: 0000 [#1] PREEMPT SMP
Date: Wed, 11 Jun 2008 13:19:59 +0200
Message-ID: <868wxcuskg.fsf@acer.nord-com.it>
References: <863ank6zmd.fsf@acer.nord-com.it> <19f34abd0806110352s53628c2bi634028b954ee6cde@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 217.141.18.130
X-Archive: encrypt
Mail-Copy-To: never
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
Cancel-Lock: sha1:4PwWabP2h5VKlw6ZKwaAiBkzGiw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=

"Vegard Nossum" <vegard.nossum@gmail.com> writes:

> On 6/11/08, Walter Franzini <walter.franzini@gmail.com> wrote:
>>  ------------------------------------------------------------------------
>>  Oops: 0000 [#1] PREEMPT SMP
>
> Is this the first line of the report that you have? Looks like there
> could be more useful information just before this.

You are right, I missed something:

------------------------------------------------------------------------
BUG: unable to handle kernel paging request at 7c30302e
IP: [<c014d949>] get_page_from_freelist+0x171/0x397
*pde = 00000000
Oops: 0000 [#1] PREEMPT SMP
------------------------------------------------------------------------

--
Walter Franzini
http://aegis.stepbuild.org/

PGP Public key ID: 1024D/CB3FEB43
Key fingerprint  : FA26 C33B CAFF 7848 EFEB  7327 96AA 2D57 CB3F EB43
Key server       : http://www.keyserver.net

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIT7TilqotV8s/60MRAp4zAJ4rMwk7vHhYyQagu7rGzMJ2Qk3c+QCgh1Pn
KPlU6t/gXHosjykSNL09yRk=
=gtFL
-----END PGP SIGNATURE-----
--=-=-=--

