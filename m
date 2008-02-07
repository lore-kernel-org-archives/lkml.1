Return-Path: <linux-kernel-owner+w=401wt.eu-S1757784AbYBGP60@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757784AbYBGP60 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 10:58:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752173AbYBGP6P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 10:58:15 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:41160 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898AbYBGP6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 10:58:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type;
        b=UntV3giTs72rKjF+w5r+dPD9UFjTl0T/YtSLOr+flBi9lizmA7PXDXzQpQrBYpfTEHZGDXbyn0FehnCfICOTM4ukC8vVvInTs1zGiIsuKmHDxLIqnbkFkwMfc+T5oZ+hsEdThozSSqEVogGnaFRHKl3jAaswcT8zOAmlW+5/Xqk=
Message-ID: <eb3ff54b0802070758j21299257m19e04fffdedd914@mail.gmail.com>
Date: Thu, 7 Feb 2008 17:58:07 +0200
From: "Rami Rosen" <ramirose@gmail.com>
To: "David Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH] [IPV6] Minor clenup: remove two unused definitions in net/ip6_route.h
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_12902_26217834.1202399887642"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_12902_26217834.1202399887642
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,
Remove IP6_RT_PRIO_FW and IP6_RT_FLOW_MASK definitions in
include/net/ip6_route.h, as they are not used in the kernel.

Regards,
Rami Rosen


Signed-off-by: Rami Rosen <ramirose@gmail.com>

------=_Part_12902_26217834.1202399887642
Content-Type: text/plain; name=patch.txt
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fcdhrl4l0
Content-Disposition: attachment; filename=patch.txt

ZGlmZiAtLWdpdCBhL2luY2x1ZGUvbmV0L2lwNl9yb3V0ZS5oIGIvaW5jbHVkZS9uZXQvaXA2X3Jv
dXRlLmgKaW5kZXggZmFhYzBlZS4uZjk5ZTRmMCAxMDA2NDQKLS0tIGEvaW5jbHVkZS9uZXQvaXA2
X3JvdXRlLmgKKysrIGIvaW5jbHVkZS9uZXQvaXA2X3JvdXRlLmgKQEAgLTEsMTEgKzEsOSBAQAog
I2lmbmRlZiBfTkVUX0lQNl9ST1VURV9ICiAjZGVmaW5lIF9ORVRfSVA2X1JPVVRFX0gKIAotI2Rl
ZmluZSBJUDZfUlRfUFJJT19GVwkJMTYKICNkZWZpbmUgSVA2X1JUX1BSSU9fVVNFUgkxMDI0CiAj
ZGVmaW5lIElQNl9SVF9QUklPX0FERFJDT05GCTI1NgogI2RlZmluZSBJUDZfUlRfUFJJT19LRVJO
CTUxMgotI2RlZmluZSBJUDZfUlRfRkxPV19NQVNLCTB4MDBmZgogCiBzdHJ1Y3Qgcm91dGVfaW5m
byB7CiAJX191OAkJCXR5cGU7Cg==
------=_Part_12902_26217834.1202399887642--
