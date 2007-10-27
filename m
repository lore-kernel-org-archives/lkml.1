Return-Path: <linux-kernel-owner+w=401wt.eu-S1756711AbXJ0Qt2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756711AbXJ0Qt2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 12:49:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753473AbXJ0QtS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 12:49:18 -0400
Received: from mx34.mail.ru ([194.67.23.200]:20598 "EHLO mx34.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753357AbXJ0QtR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 12:49:17 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: Alexey Starikovskiy <aystarik@gmail.com>
Subject: Re: [2.624-rc1 regression] lost battery information
Date: Sat, 27 Oct 2007 20:49:10 +0400
User-Agent: KMail/1.9.7
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Frans Pop <elendil@planet.nl>
References: <200710262024.06012.arvidjaar@mail.ru> <200710271855.52866.arvidjaar@mail.ru> <47235727.30808@gmail.com>
In-Reply-To: <47235727.30808@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2516943.8kO8jsetPJ";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200710272049.11969.arvidjaar@mail.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2516943.8kO8jsetPJ
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Saturday 27 October 2007, Alexey Starikovskiy wrote:
> As you wish... :) Please check the attached patch.
>

Not sure why you need to reimplement acpi_extract_package, but ...

Tested-by: Andrey Borzenkov <arvidjaar@mail.ru>

--nextPart2516943.8kO8jsetPJ
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBHI2wHR6LMutpd94wRAprvAJ4wX4OVrjqYEfqEyJJpc+ZksinWlgCeL8Ly
GnV7/diYr7hk8BJTInEmxuI=
=u/P7
-----END PGP SIGNATURE-----

--nextPart2516943.8kO8jsetPJ--
