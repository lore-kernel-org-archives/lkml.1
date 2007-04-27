Return-Path: <linux-kernel-owner+w=401wt.eu-S1753215AbXD0R2O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215AbXD0R2O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 13:28:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751197AbXD0R2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 13:28:14 -0400
Received: from mx20.brocade.com ([66.243.153.19]:43095 "EHLO mx20.brocade.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756089AbXD0R2M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 13:28:12 -0400
X-IronPort-AV: i="4.14,462,1170662400"; 
   d="c'?txt'?gz'50?tar'50,49?scan'50,49,208,49,50"; a="8762652:sNHT36867040"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C788F1.6D9AE5C5"
Subject: RE: [PATCH 1/1] IBM PPC EMAC driver:improved support for PHY,resending
Date: Fri, 27 Apr 2007 10:28:10 -0700
Message-ID: <46F9780F64AE9945815725F4C0C72CB802A6E0DA@hq-exch-1.corp.brocade.com>
In-Reply-To: <1177645682.14873.292.camel@localhost.localdomain>
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 1/1] IBM PPC EMAC driver:improved support for PHY,resending
Thread-Index: AceIft3uAhQ/Fos+TXi1tHdPrRj6AwAcSEIw
From: "Jeff Haran" <jharan@Brocade.COM>
To: "Benjamin Herrenschmidt" <benh@kernel.crashing.org>
Cc: <ebs@ebshome.net>, <linux-kernel@vger.kernel.org>,
       "Jeff Haran" <jharan@Brocade.COM>
X-OriginalArrivalTime: 27 Apr 2007 17:28:11.0641 (UTC) FILETIME=[6DF1D690:01C788F1]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

------_=_NextPart_001_01C788F1.6D9AE5C5
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: quoted-printable


> -----Original Message-----
> From: Benjamin Herrenschmidt [mailto:benh@kernel.crashing.org]=20
> Sent: Thursday, April 26, 2007 8:48 PM
> To: Jeff Haran
> Cc: ebs@ebshome.net; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH 1/1] IBM PPC EMAC driver:improved support=20
> for PHY,resending
>=20
> On Thu, 2007-04-26 at 18:18 -0700, Jeff Haran wrote:
> > From: Jeff Haran  <jharan@brocade.com>
> >=20
> > Resending with Outlook patch mangling hopefully corrected (Maybe I
> > should write a HOWTO, this was harder than fixing the driver).
>=20
> Note, sorry about that, still mangled :-(
>=20
> Just send it as an attachment ... and get yourself a linux desktop :-)
>=20
> Cheers,
> Ben.
>=20

Ben,

OK. Attached is a gziped tar file named patch.tar.gz containing the
following:

patch - The patch file, hopefully ungarbled.
ibm_emac_phy.c - The modified source file, in case the patch file is
still wrong.
log.txt - A log of what I did to create the patch, in case I bungled
that too.

Note I created the patch using the instructions in
Documentation/SubmittingPatches.

Let me know if this gets thru ok. If not, I can try Morse Code.

Jeff Haran

------_=_NextPart_001_01C788F1.6D9AE5C5
Content-Type: application/x-gzip;
	name="patch.tar.gz"
Content-Transfer-Encoding: base64
Content-Description: patch.tar.gz
Content-Disposition: attachment;
	filename="patch.tar.gz"

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
27Zt27Zt27Zt27Zt239T+zfS5gNCAFAAAA==

------_=_NextPart_001_01C788F1.6D9AE5C5--
