Return-Path: <linux-kernel-owner+w=401wt.eu-S1753665AbZI3ATW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753665AbZI3ATW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 20:19:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753116AbZI3ATV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 20:19:21 -0400
Received: from mail-yx0-f199.google.com ([209.85.210.199]:62716 "EHLO
	mail-yx0-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699AbZI3ATU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 20:19:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=j0iWfop1o6Se2E6O/kWfk9Kl4uinEov5WUt45bSQ+I0bcrY5M9FHd6LdVmVukfN0yt
         JPcfPLXrtI+kU/p9xkXEGcaO/lP+b3sNTNz466CgpWFeR9stgqHAIT20pSuHQ3oTLe2C
         UEaiPteUUJz+GSjApeIl/HPEUQ4D4z8ISgX7A=
Date: Wed, 30 Sep 2009 00:18:57 +0000
From: Andy Spencer <andy753421@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] Permission masking security module (was dpriv)
Message-ID: <20090930001856.GA28312@c.hsd1.tn.comcast.net>
References: <20090923005644.GA28244@c.hsd1.tn.comcast.net>
 <20090929071010.GA17782@c.hsd1.tn.comcast.net>
 <20090929174441.GE7209@kroah.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_c-28427-1254269961-0001-2"
Content-Disposition: inline
In-Reply-To: <20090929174441.GE7209@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_c-28427-1254269961-0001-2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

> What is this patch for?  Care to break it out separate with a
> different changelog comment and push it upstream now if it is needed?

It fixes a bug in sscanf when using, for example, `%*s%n'.

I posted a separate patch for this a few days ago, but it hasn't been
merged upstream so I included that change here as well.

For reference: http://lkml.org/lkml/2009/9/25/31

--=_c-28427-1254269961-0001-2
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkrCpAgACgkQz1OYJ/s1XTCHpgCeK8S6wFJ4K8Ha/zaV/IhrdfVf
JA0AoJlTc7JGHtU59EbCXAum+2TWiCby
=vbR9
-----END PGP SIGNATURE-----

--=_c-28427-1254269961-0001-2--
