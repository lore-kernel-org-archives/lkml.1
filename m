Return-Path: <linux-kernel-owner+w=401wt.eu-S1753556AbYIQCm4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556AbYIQCm4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 22:42:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752677AbYIQCmt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 22:42:49 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:47443 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752667AbYIQCms (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 22:42:48 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Alessio Sangalli <alesan@manoweb.com>
Cc: Ben Nizette <bn@niasdigital.com>, Ben Dooks <ben-linux@fluff.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Driver for tightly coupled memory
In-Reply-To: Your message of "Tue, 16 Sep 2008 15:49:53 PDT."
             <48D03811.9070805@manoweb.com>
From: Valdis.Kletnieks@vt.edu
References: <48CEC71F.3000006@manoweb.com> <20080916093513.GF1916@fluff.org.uk> <48CFEF3F.5040901@manoweb.com> <1221604022.3598.4.camel@moss.renham>
            <48D03811.9070805@manoweb.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1221619342_8266P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 16 Sep 2008 22:42:22 -0400
Message-ID: <24229.1221619342@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1221619342_8266P
Content-Type: text/plain; charset=us-ascii

On Tue, 16 Sep 2008 15:49:53 PDT, Alessio Sangalli said:

> In this case however, do you imply that a device driver will just do all
> the genalloc stuff? In this case it has to know about the TCM details,

What sort of hardware/software interface does the TCM provide?  You mentioned
that it could be accessed even while main memory is being accessed - what does
that look like from the software level?

--==_Exmh_1221619342_8266P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFI0G6OcC3lWbTT17ARAhptAKCOV5mp70Srgqm0lXuXQDu+e1kzGACfSl8E
l25HSi9AaUOH9Lu8oG/mUcU=
=3VeX
-----END PGP SIGNATURE-----

--==_Exmh_1221619342_8266P--
