Return-Path: <linux-kernel-owner+w=401wt.eu-S1755909AbYJPRtq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755909AbYJPRtq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 13:49:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752471AbYJPRti
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 13:49:38 -0400
Received: from mail-in-03.arcor-online.net ([151.189.21.43]:40985 "EHLO
	mail-in-03.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752187AbYJPRth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 13:49:37 -0400
Date: Thu, 16 Oct 2008 20:00:31 +0200 (CEST)
From: Bodo Eggert <7eggert@gmx.de>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>
cc: Bodo Eggert <7eggert@gmx.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Use PC-BIOS NUMLOCK flag
In-Reply-To: <20081016143856.GD5071@const.bordeaux.inria.fr>
Message-ID: <alpine.LSU.0.999.0810161958450.5051@be1.lrz>
References: <alpine.LSU.0.999.0810161358540.5404@be1.lrz>
 <20081016143856.GD5071@const.bordeaux.inria.fr>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323584-1389964400-1224180031=:5051"
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323584-1389964400-1224180031=:5051
Content-Type: TEXT/PLAIN; charset=iso-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Thu, 16 Oct 2008, Samuel Thibault wrote:
> Bodo Eggert, le Thu 16 Oct 2008 13:59:49 +0200, a =E9crit :

> > +=09  If you have an alternative firmware like OpenFirmware or LinuxBio=
s,
> > +=09  this flag might not be set correctly, which results in a random s=
tate
> > +=09  of the Numlock key.
>=20
> That's an issue. That means that distributions will just not enable,
> and thus the flag is not really useful, since people who would
> compile their own kernel would very likely have already setup their
> initialization scripts into calling setleds +num (or just set LEDS=3D+num
> in /etc/console-tools/config on a debian machine).

I hope somebody will pop up and say "Hey, those will create an IBM PC data=
=20
area, because they run DOS" ...
--=20
"Try to look unimportant; they may be low on ammo."
-Infantry Journal
--8323584-1389964400-1224180031=:5051--
