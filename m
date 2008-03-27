Return-Path: <linux-kernel-owner+w=401wt.eu-S1757748AbYC0JGP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757748AbYC0JGP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 05:06:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754390AbYC0JF6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 05:05:58 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:62447 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753730AbYC0JF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 05:05:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:mime-version:content-type;
        b=jzVJStr4Mvc4UFwTRbHS4uHBhmtoQOGGJ06y0slEVyidi59M/VcandaxkHM6P56c/PfGgWN8Y6OfgLZhic/6jrpT9xnQdA2GkZKbKmVJJ7ja2EAwJLcUY/ZujXwxFzBuL538qCQYt4prk4Nxq9GtzSyit0o3Tl86plFtqcGAhoA=
Message-ID: <eb3ff54b0803270205n4a15a884kaa45852e510b27c6@mail.gmail.com>
Date: Thu, 27 Mar 2008 11:05:55 +0200
From: "Rami Rosen" <ramirose@gmail.com>
To: "David Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-2.6.26] Remove three unused method declarations in include/net/ipv6.h
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_14242_33134566.1206608755587"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_14242_33134566.1206608755587
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,
This patch removes three unused method declarations in include/net/ipv6.h:
inet_getfrag_t(), ipv6_build_nfrag_opts() and ipv6_build_frag_opts().

Regards,
Rami Rosen


Signed-off-by: Rami Rosen <ramirose@gmail.com>

------=_Part_14242_33134566.1206608755587
Content-Type: text/plain; name=patch.txt
Content-Transfer-Encoding: base64
X-Attachment-Id: f_feb3g0hc0
Content-Disposition: attachment; filename=patch.txt

ZGlmZiAtLWdpdCBhL2luY2x1ZGUvbmV0L2lwdjYuaCBiL2luY2x1ZGUvbmV0L2lwdjYuaAppbmRl
eCAyOTZmNjFkLi41NzM4YzFjIDEwMDY0NAotLS0gYS9pbmNsdWRlL25ldC9pcHY2LmgKKysrIGIv
aW5jbHVkZS9uZXQvaXB2Ni5oCkBAIC0yNTAsMTUgKzI1MCw2IEBAIGludCBpcDZfZnJhZ19tZW0o
c3RydWN0IG5ldCAqbmV0KTsKIAogI2RlZmluZSBJUFY2X0ZSQUdfVElNRU9VVAkoNjAqSFopCQkv
KiA2MCBzZWNvbmRzICovCiAKLS8qCi0gKglGdW5jdGlvbiBwcm90b3R5cGUgZm9yIGJ1aWxkX3ht
aXQKLSAqLwotCi10eXBlZGVmIGludAkJKCppbmV0X2dldGZyYWdfdCkgKGNvbnN0IHZvaWQgKmRh
dGEsCi0JCQkJCSAgIHN0cnVjdCBpbjZfYWRkciAqYWRkciwKLQkJCQkJICAgY2hhciAqLAotCQkJ
CQkgICB1bnNpZ25lZCBpbnQsIHVuc2lnbmVkIGludCk7Ci0KIGV4dGVybiBpbnQgX19pcHY2X2Fk
ZHJfdHlwZShjb25zdCBzdHJ1Y3QgaW42X2FkZHIgKmFkZHIpOwogc3RhdGljIGlubGluZSBpbnQg
aXB2Nl9hZGRyX3R5cGUoY29uc3Qgc3RydWN0IGluNl9hZGRyICphZGRyKQogewpAQCAtNTEwLDE0
ICs1MDEsNiBAQCBleHRlcm4gaW50CQkJaXA2X2xvY2FsX291dChzdHJ1Y3Qgc2tfYnVmZiAqc2ti
KTsKICAqCUV4dGVuc2lvbiBoZWFkZXIgKG9wdGlvbnMpIHByb2Nlc3NpbmcKICAqLwogCi1leHRl
cm4gdTggKgkJCWlwdjZfYnVpbGRfbmZyYWdfb3B0cyhzdHJ1Y3Qgc2tfYnVmZiAqc2tiLAotCQkJ
CQkJICAgICAgdTggKnByZXZfaGRyLAotCQkJCQkJICAgICAgc3RydWN0IGlwdjZfdHhvcHRpb25z
ICpvcHQsCi0JCQkJCQkgICAgICBzdHJ1Y3QgaW42X2FkZHIgKmRhZGRyLAotCQkJCQkJICAgICAg
dTMyIGp1bWJvbGVuKTsKLWV4dGVybiB1OCAqCQkJaXB2Nl9idWlsZF9mcmFnX29wdHMoc3RydWN0
IHNrX2J1ZmYgKnNrYiwKLQkJCQkJCSAgICAgdTggKnByZXZfaGRyLAotCQkJCQkJICAgICBzdHJ1
Y3QgaXB2Nl90eG9wdGlvbnMgKm9wdCk7CiBleHRlcm4gdm9pZCAJCQlpcHY2X3B1c2hfbmZyYWdf
b3B0cyhzdHJ1Y3Qgc2tfYnVmZiAqc2tiLAogCQkJCQkJICAgICBzdHJ1Y3QgaXB2Nl90eG9wdGlv
bnMgKm9wdCwKIAkJCQkJCSAgICAgdTggKnByb3RvLAo=
------=_Part_14242_33134566.1206608755587--
