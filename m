Return-Path: <linux-kernel-owner+w=401wt.eu-S1759571AbYJVVNf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759571AbYJVVNf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 17:13:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753250AbYJVVNZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 17:13:25 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:40825 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752703AbYJVVNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 17:13:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type;
        b=icSHLb+/Ni0beANNJEDHd7ldsNaCo5YFscR6gZ/iYm/thHvfB1Xop+vreBhPFD7a7U
         SYarEpO6/gRDOsQVp04lC89xJlt8tzhb1TrCaH+QHmgep2cfk5FRz2viwfVuGkhLzG1F
         MUKQTqddJzKdin26rp4Ts5shbRvd+4Iu0WwdQ=
Message-ID: <d9def9db0810221413s152f6fa7s21caffbfa3fa5712@mail.gmail.com>
Date: Wed, 22 Oct 2008 23:13:20 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       em28xx <em28xx@mcentral.de>
Subject: [PATCH 7/7] adding common used headers
Cc: acano@fastmail.fm, "Andre Kelmanson" <akelmanson@gmail.com>,
       "Bouwsma Barry" <freebeer.bouwsma@gmail.com>,
       "Dan Kreiser" <kreiser@informatik.hu-berlin.de>,
       "Frank Neuber" <fn@kernelport.de>,
       "Jelle de Jong" <jelledejong@powercraft.nl>,
       "John Stowers" <john.stowers.lists@gmail.com>,
       "Lukas Kuna" <lukas.kuna@evkanet.net>,
       "Stefan Vonolfen" <stefan.vonolfen@gmail.com>,
       "Stephan Berberig" <s.berberig@arcor.de>,
       "Thomas Giesecke" <thomas.giesecke@ibgmbh-naumburg.de>,
       "Vitaly Wool" <vwool@ru.mvista.com>, "Zhenyu Wang" <zhen78@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_25581_9210577.1224710001017"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_25581_9210577.1224710001017
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

    adding common used headers

    tunerchip.h:
    just contains an internal used struct which can be used for
setting up a tuner frontend.

------=_Part_25581_9210577.1224710001017
Content-Type: text/x-diff; name=em28xx-07.diff
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fmmgpbtz0
Content-Disposition: attachment; filename=em28xx-07.diff

Y29tbWl0IGY2N2E0NGQxNGE4NDdlM2ZjYzRmZDc0ZDE2NjA2NjY1MzVjMjY5MDUKQXV0aG9yOiBN
YXJrdXMgUmVjaGJlcmdlciA8bXJlY2hiZXJnZXJAc3VuZHRlay5kZT4KRGF0ZTogICBXZWQgT2N0
IDIyIDIyOjE0OjE3IDIwMDggKzAyMDAKCiAgICBhZGRpbmcgY29tbW9uIHVzZWQgaGVhZGVycwog
ICAgCiAgICB0dW5lcmNoaXAuaDoKICAgIGp1c3QgY29udGFpbnMgYW4gaW50ZXJuYWwgdXNlZCBz
dHJ1Y3Qgd2hpY2ggY2FuIGJlIHVzZWQgZm9yIHNldHRpbmcgdXAgYSB0dW5lciBmcm9udGVuZC4K
ClNpZ25lZC1vZmYtYnk6IE1hcmt1cyBSZWNoYmVyZ2VyIDxtcmVjaGJlcmdlckBzdW5kdGVrLmRl
PgoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWVkaWEvdmlkZW8vZW1waWEvaW5jbHVkZS90dW5lcmNo
aXAuaCBiL2RyaXZlcnMvbWVkaWEvdmlkZW8vZW1waWEvaW5jbHVkZS90dW5lcmNoaXAuaApuZXcg
ZmlsZSBtb2RlIDEwMDY0NAppbmRleCAwMDAwMDAwLi43NWJhOGU2Ci0tLSAvZGV2L251bGwKKysr
IGIvZHJpdmVycy9tZWRpYS92aWRlby9lbXBpYS9pbmNsdWRlL3R1bmVyY2hpcC5oCkBAIC0wLDAg
KzEsMzIgQEAKKyNpZm5kZWYgX1RVTkVSX0NISVBfSAorI2RlZmluZSBfVFVORVJfQ0hJUF9ICisK
K3N0cnVjdCB0dW5lcl9tb2R1bGUgeworCXZvaWQgKnByaXY7CisgICAgICAgIGludCAoKnR1bmVy
X2NtZCkoc3RydWN0IHR1bmVyX21vZHVsZSAqY2xpZW50LCB1bnNpZ25lZCBpbnQgY21kLCB2b2lk
ICpkYXRhKTsKKyAgICAgICAgaW50ICgqc2h1dGRvd24pKHN0cnVjdCB0dW5lcl9tb2R1bGUgKmNs
aWVudCk7CisgICAgICAgIGludCAoKnNldF9mcmVxdWVuY3kpKHN0cnVjdCB0dW5lcl9tb2R1bGUg
KmNsaWVudCwgdW5zaWduZWQgbG9uZyBmcmVxdWVuY3lfaW5faHopOworICAgICAgICBpbnQgKCpn
ZXRfZnJlcXVlbmN5X2Vycm9yKShzdHJ1Y3QgdHVuZXJfbW9kdWxlICpjbGllbnQsIGxvbmcgKmZy
ZXF1ZW5jeV9lcnJvcl9taHopOworICAgICAgICBpbnQgKCpnZXRfbG9ja19zdGF0dXMpKHN0cnVj
dCB0dW5lcl9tb2R1bGUgKmNsaWVudCwgdW5zaWduZWQgc2hvcnQgaW50ICpsb2NrX3N0YXR1cyk7
CisgICAgICAgIGludCAoKmdldF92ZXJzaW9uKShzdHJ1Y3QgdHVuZXJfbW9kdWxlICpjbGllbnQs
IHVuc2lnbmVkIGNoYXIqIGh3X21ham9ydmVyc2lvbiwgdW5zaWduZWQgY2hhciogaHdfbWlub3J2
ZXJzaW9uLCB1bnNpZ25lZCBjaGFyKiBmd19tYWpvcnZlcnNpb24sIHVuc2lnbmVkIGNoYXIqIGZ3
X21pbm9ydmVyc2lvbik7CisgICAgICAgIGludCAoKmZ1bGxfc2Nhbikoc3RydWN0IHR1bmVyX21v
ZHVsZSAqY2xpZW50LCB1bnNpZ25lZCBpbnQgZnJlcV9taW4sIHVuc2lnbmVkIGludCBmcmVxX21h
eCwgaW50IGZyZXFfbGlzdF9zaXplLCB1bnNpZ25lZCBpbnQgKmZyZXFfbGlzdCwgaW50ICpuYl9m
cmVxX2ZvdW5kICk7CisJdm9pZCAoKnJlbGVhc2UpKHN0cnVjdCB0dW5lcl9tb2R1bGUgKmNsaWVu
dCk7Cit9OworCisjZGVmaW5lIHR1bmVyX2NoaXBfZGV0YWNoKE1PRCkgaWYoTU9EKSB7IFwKKwkJ
CQlNT0QtPnJlbGVhc2UoTU9EKTsgXAorCQkJCXN5bWJvbF9wdXRfYWRkcihNT0QtPnJlbGVhc2Up
OyBcCisJCQkgICAgICAgfQorCisjZGVmaW5lIHR1bmVyX2NoaXBfYXR0YWNoKEZVTkNUSU9OLCBB
UkdTLi4uKSAoeyBcCisJc3RydWN0IHR1bmVyX21vZHVsZSAqbW9kID0gTlVMTDsgXAorCXR5cGVv
ZigmRlVOQ1RJT04pIF9fYSA9IHN5bWJvbF9yZXF1ZXN0KEZVTkNUSU9OKTsgXAorCWlmIChfX2Ep
IHsgIFwKKwkJbW9kPV9fYShBUkdTKTsgXAorCQlpZiAobW9kID09IDApIFwKKwkJCXN5bWJvbF9w
dXQoX19hKTsgXAorCX0gXAorCW1vZDsgXAorfSkKKworI2VuZGlmCg==
------=_Part_25581_9210577.1224710001017--
