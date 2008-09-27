Return-Path: <linux-kernel-owner+w=401wt.eu-S1753856AbYI0SIa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856AbYI0SIa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 14:08:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752872AbYI0SIU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 14:08:20 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:62219 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752428AbYI0SIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 14:08:19 -0400
From: Javier Guerra Giraldez <javier@guerrag.com>
To: "Zhao, Yu" <yu.zhao@intel.com>
Subject: Re: [PATCH 0/6 v3] PCI: Linux kernel SR-IOV support
Date: Sat, 27 Sep 2008 13:07:57 -0500
User-Agent: KMail/1.9.10
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Grant Grundler <grundler@parisc-linux.org>,
       Alex Chiang <achiang@hp.com>, Matthew Wilcox <matthew@wil.cx>,
       Roland Dreier <rdreier@cisco.com>, Greg KH <greg@kroah.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
References: <D8078B8B3B09934AA9F8F2D5FB3F28CE088751B5EF@pdsmsx502.ccr.corp.intel.com>
In-Reply-To: <D8078B8B3B09934AA9F8F2D5FB3F28CE088751B5EF@pdsmsx502.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart407519406.Zl8rDPkWmg";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200809271308.03547.javier@guerrag.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart407519406.Zl8rDPkWmg
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Saturday 27 September 2008, Zhao, Yu wrote:
> Greetings,
>
> Following patches are intended to support SR-IOV capability in the Linux
> kernel. With these patches, people can turn a PCI device with the
> capability into multiple ones from software perspective, which can benefit
> KVM and achieve other purposes such as QoS, security, etc.

sounds great, i think some Infiniband HBAs have this capability; they even=
=20
suggested using on Xen for faster (no hypervisor intervention) communicatio=
n=20
between DomU's on the same box. (and transparently to out of the box, of=20
course)

does it need an IOMMU (VT-d), or the whole magic is done by the PCI device?

=2D-=20
Javier

--nextPart407519406.Zl8rDPkWmg
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBI3naDsIoGnxsRK/ERAkVHAJ9tbeSSfMU0bH4M9t0HkpwypJD0wACdHDkx
gAPBfS5TDfIR3MWW5SNQ7RE=
=leKK
-----END PGP SIGNATURE-----

--nextPart407519406.Zl8rDPkWmg--
