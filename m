Return-Path: <linux-kernel-owner+w=401wt.eu-S1752323AbYHIRIC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752323AbYHIRIC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 13:08:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750749AbYHIRHx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 13:07:53 -0400
Received: from n45.bullet.mail.ukl.yahoo.com ([87.248.110.178]:45192 "HELO
	n45.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750725AbYHIRHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 13:07:52 -0400
X-Yahoo-Newman-Id: 549201.49910.bm@omp214.mail.ukl.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.it;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=DG6NOO7EzZpdy0gmouHFRHHVNPFZeoGdDE+CYP+2E/C8/8Iobu0UlT9KBbFYCAbZDgGqq44DvQC0qtLxgujhFi+iCzKjXrT9imK9WlgrYVeB9Y5BT2RPRrXSF5hLPbTlxEtxS+lVCedigYyuXKRoivgyb3iRrOxNPN5HI4zMqd0=  ;
X-YMail-OSG: r9YQbk0VM1mac_Ntyp7zZGAzOfGHNn4Vxg_cmsJEUMUNF9dCsiqTP5kfuBfMrx0LrkSG7Sa0eS6gck7CblMtl5H4s1ANm2VZutSJ2rcnTQ4N7QIGlGwCo3kI1iL57To-
X-Yahoo-Newman-Property: ymail-3
From: Blaisorblade <blaisorblade@yahoo.it>
To: Tomas Carnecky <tom@dbservice.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: check kconfig
Date: Sat, 9 Aug 2008 19:07:38 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
References: <488B935A.4080805@dbservice.com>
In-Reply-To: <488B935A.4080805@dbservice.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1636208.b6hUXWTrm8";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200808091907.43733.blaisorblade@yahoo.it>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1636208.b6hUXWTrm8
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On sabato 26 luglio 2008, Tomas Carnecky wrote:
> I ran your script, it still shows heaps of unused CONFIG_ defines in the
> kernel sources. Is anyone actually cleaning those up?
>
> tom
Sorry for late answer. I'm not working on this (and I've not time to work o=
n=20
any kernel stuff, currently), as you might have guessed (even from the lack=
=20
of an answer).

You could maybe help yourself, and you could also suggest this task to=20
kernel-janitors (look for it on Google, it's a collection of simple tasks f=
or=20
wannabe kernel hackers).

The problem is that cleaning up such stuff isn't always trivial, one must f=
ind=20
out why there is a mention of an unknown symbol, and fix the original=20
problem. If one discover that some source is never built, maybe the symbol=
=20
should be reintroduced. And so on.

Good bye and good luck
=2D-=20
"Doh!" (cit.), I've made another mistake!
Paolo Giarrusso, aka Blaisorblade
Linux registered user n. 292729
http://www.user-mode-linux.org/~blaisorblade

--nextPart1636208.b6hUXWTrm8
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBInc7fqH9OHC+5NscRAhCxAJwJVsqwB/ZJgbSP1GOctePfZs7VGACfZEwQ
5aMQyQbgnq/n9i4mZzKJSnM=
=HrTN
-----END PGP SIGNATURE-----

--nextPart1636208.b6hUXWTrm8--

