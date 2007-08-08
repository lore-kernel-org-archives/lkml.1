Return-Path: <linux-kernel-owner+w=401wt.eu-S1760959AbXHHHZS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760959AbXHHHZS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 03:25:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756754AbXHHHYi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 03:24:38 -0400
Received: from rv-out-0910.google.com ([209.85.198.189]:21335 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755815AbXHHHYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 03:24:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type;
        b=YNrrmlKlHO8MsFcc7ABJItKr6lj5wP1d3JmV/BsRum6NWb7J9qQJZUfyRr50KGlpwS/rNBUzXjHhjXwExHQ/BNJBLeMasblITlxGjyZ8ToQHFfOBTTCv3yPZzmItH/0h9kispBfFDQ1xn14x6O89iSmdj625guqLw4rD5Y9fs5U=
Message-ID: <ed7dcf450708080024s719a4e92x782cafbe5811c012@mail.gmail.com>
Date: Wed, 8 Aug 2007 09:24:35 +0200
From: "=?ISO-8859-1?Q?S=F8ren_Hauberg?=" <hauberg@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Support for the Evolution Scorpion Robot
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_35507_14365855.1186557875178"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_35507_14365855.1186557875178
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi,
  I'm currently running a patched version of 2.6.20 in order to use
the Evolution Scorpion robot. For this robot to work I need to patch
the kernel with a fairly simple patch that I'm attaching in case you
want to apply it.

Cheers,
S=F8ren

P.S. On not subscribed to this list, so please CC me if you have any
replies. Thanks.

------=_Part_35507_14365855.1186557875178
Content-Type: application/octet-stream; name="ftdi_sio.c.patch-2.6.20"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="ftdi_sio.c.patch-2.6.20"
X-Attachment-Id: f_f53hwxhd

LS0tIGZ0ZGlfc2lvLmMuYmFrCTIwMDctMDgtMDcgMjE6Mzc6MzcuMDAwMDAwMDAwICswMjAwCisr
KyBmdGRpX3Npby5jCTIwMDctMDgtMDcgMjE6NTM6MzYuMDAwMDAwMDAwICswMjAwCkBAIC00ODgs
NiArNDg4LDggQEAKIAl7IFVTQl9ERVZJQ0UoRlRESV9WSUQsIEZURElfVEVSQVRST05JS19WQ1Bf
UElEKSB9LAogCXsgVVNCX0RFVklDRShGVERJX1ZJRCwgRlRESV9URVJBVFJPTklLX0QyWFhfUElE
KSB9LAogCXsgVVNCX0RFVklDRShFVk9MVVRJT05fVklELCBFVk9MVVRJT05fRVIxX1BJRCkgfSwK
KyAgICAgICAgeyBVU0JfREVWSUNFKEVWT0xVVElPTl9WSUQsIEVWT19IWUJSSURfUElEKSB9LAor
ICAgICAgICB7IFVTQl9ERVZJQ0UoRVZPTFVUSU9OX1ZJRCwgRVZPX1JDTTRfUElEKSB9LAogCXsg
VVNCX0RFVklDRShGVERJX1ZJRCwgRlRESV9BUlRFTUlTX1BJRCkgfSwKIAl7IFVTQl9ERVZJQ0Uo
RlRESV9WSUQsIEZURElfQVRJS19BVEsxNl9QSUQpIH0sCiAJeyBVU0JfREVWSUNFKEZURElfVklE
LCBGVERJX0FUSUtfQVRLMTZDX1BJRCkgfSwKQEAgLTgxOSw2ICs4MjEsMTIgQEAKIAogCWJhdWQg
PSB0dHlfZ2V0X2JhdWRfcmF0ZShwb3J0LT50dHkpOwogCWRiZygiJXMgLSB0dHlfZ2V0X2JhdWRf
cmF0ZSByZXBvcnRzIHNwZWVkICVkIiwgX19GVU5DVElPTl9fLCBiYXVkKTsKKyAJLyogY29udmVy
dCBiYXVkIHJhdGUgZnJvbSAyMzBLIHRvIDI1MEsgZm9yIFJDTSBkZXZpY2UgKi8KKyAgICAJaWYg
KCBiYXVkID09IDIzMDQwMCAmJiBwb3J0LT5zZXJpYWwtPmRldi0+ZGVzY3JpcHRvci5pZFZlbmRv
ciA9PSBFVk9MVVRJT05fVklEICkKKyAgICAJICB7CisJICAgIGJhdWQgPSAyNTAwMDA7CisgICAg
ICAgICAgICBkYmcoIiVzOiBidW1wZWQgbWFnaWNhbCAyMzA0MDAgYmF1ZCB0byAyLjVrYiIsIF9f
RlVOQ1RJT05fXyk7CisgICAgCSAgfQogCiAJLyogMi4gT2JzZXJ2ZSBhc3luYy1jb21wYXRpYmxl
IGN1c3RvbV9kaXZpc29yIGhhY2ssIHVwZGF0ZSBiYXVkcmF0ZSBpZiBuZWVkZWQgKi8KIAo=
------=_Part_35507_14365855.1186557875178
Content-Type: application/octet-stream; name="ftdi_sio.h.patch-2.6.20"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="ftdi_sio.h.patch-2.6.20"
X-Attachment-Id: f_f53hx1u6

LS0tIGZ0ZGlfc2lvLmguYmFrCTIwMDctMDgtMDcgMjE6Mzc6NDMuMDAwMDAwMDAwICswMjAwCisr
KyBmdGRpX3Npby5oCTIwMDctMDgtMDcgMjE6Mzk6NDguMDAwMDAwMDAwICswMjAwCkBAIC00MTks
NiArNDE5LDkgQEAKICAqLwogI2RlZmluZSBFVk9MVVRJT05fVklECQkweERFRUUJLyogVmVuZG9y
IElEICovCiAjZGVmaW5lIEVWT0xVVElPTl9FUjFfUElECTB4MDMwMAkvKiBFUjEgQ29udHJvbCBN
b2R1bGUgKi8KKyNkZWZpbmUgRVZPXzhVMjMyQU1fUElEIDB4MDJGRiAvKiBFdm9sdXRpb24gcm9i
b3RpY3MgUkNNMiAoRlQyMzJBTSkqLworI2RlZmluZSBFVk9fSFlCUklEX1BJRCAgMHgwMzAyIC8q
IEV2b2x1dGlvbiByb2JvdGljcyBSQ000IFBJRCAoRlQyMzJCTSkqLworI2RlZmluZSBFVk9fUkNN
NF9QSUQgICAgMHgwMzAzIC8qIEV2b2x1dGlvbiByb2JvdGljcyBSQ000IFBJRCAqLwogCiAvKiBQ
eXJhbWlkIENvbXB1dGVyIEdtYkggKi8KICNkZWZpbmUgRlRESV9QWVJBTUlEX1BJRAkweEU2QzgJ
LyogUHlyYW1pZCBBcHBsaWFuY2UgRGlzcGxheSAqLwo=
------=_Part_35507_14365855.1186557875178--
