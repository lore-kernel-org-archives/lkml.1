Return-Path: <linux-kernel-owner+w=401wt.eu-S1755985AbZGOSE3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755985AbZGOSE3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 14:04:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755886AbZGOSE2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 14:04:28 -0400
Received: from mail-bw0-f228.google.com ([209.85.218.228]:45817 "EHLO
	mail-bw0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755747AbZGOSE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 14:04:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=GRSCSdRxeK8IO5vXKyxsI6J8MbwXq7fPTvMubMaOmLaFlwuMmhA+mtCsBzbz7Z32Ez
         apzVjO1rAqURQU6HIdarPW+EioQ2huYMb4vzb3LKxVV3f4TFqlbNQmma3aHA2WtGkoNZ
         QVl7O4yS98dKrzpiRKVfxUflE4YYr/POyv94Q=
MIME-Version: 1.0
In-Reply-To: <ac3eb2510907150946y461fee0dj6e8f5265b4f91215@mail.gmail.com>
References: <20090526152540.GA28341@sepie.suse.cz>
	 <20090703144547.GA20980@sepie.suse.cz>
	 <1247675954.3968.140.camel@quest>
	 <ac3eb2510907150946y461fee0dj6e8f5265b4f91215@mail.gmail.com>
Date: Wed, 15 Jul 2009 20:04:24 +0200
Message-ID: <cc43514a0907151104r6208a3dbm89dba496c1411fc0@mail.gmail.com>
Subject: Re: [PATCH] kbuild: generate modules.builtin
From: Andreas Robinson <andr345@gmail.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Scott James Remnant <scott@ubuntu.com>, Michal Marek <mmarek@suse.cz>,
       linux-modules@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=0016369fa30ba9f7c4046ec26200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016369fa30ba9f7c4046ec26200
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Guys,

is this patch what you need on the m-i-t end?

(Sorry for sending it as an attachment. I'm restricted to webmail at
the moment and can't prevent gmail from adding line breaks.)

Cheers,
Andreas

--0016369fa30ba9f7c4046ec26200
Content-Type: text/x-patch; charset=US-ASCII; name="check_modules_builtin.patch"
Content-Disposition: attachment; filename="check_modules_builtin.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fx6cwvy50

RnJvbSBkNjBhNGE1NmY1ZDQ4NGE2MDc2YzYwNmExMTE1MTBjZTQwYTRjY2Q4IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBBbmRyZWFzIFJvYmluc29uIDxhbmRyMzQ1QGdtYWlsLmNvbT4K
RGF0ZTogV2VkLCAxNSBKdWwgMjAwOSAxOTo0ODo1OSArMDIwMApTdWJqZWN0OiBbUEFUQ0hdIG1v
ZHByb2JlOiB3YXJuIHdoZW4gdHJ5aW5nIHRvIGluc2VydCBhIGJ1aWx0LWluIG1vZHVsZQoKVGhl
IHByZXZpb3VzIGJlaGF2aW91ciB3YXMgdG8gZmFpbCB3aXRoICJtb2R1bGUgZm9vIG5vdCBmb3Vu
ZCIuCgpTaWduZWQtb2ZmLWJ5OiBBbmRyZWFzIFJvYmluc29uIDxhbmRyMzQ1QGdtYWlsLmNvbT4K
LS0tCiBtb2Rwcm9iZS5jIHwgICAzNCArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKy0t
CiAxIGZpbGVzIGNoYW5nZWQsIDMyIGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pCgpkaWZm
IC0tZ2l0IGEvbW9kcHJvYmUuYyBiL21vZHByb2JlLmMKaW5kZXggMjFhMzExMS4uYTA5NDNmZSAx
MDA2NDQKLS0tIGEvbW9kcHJvYmUuYworKysgYi9tb2Rwcm9iZS5jCkBAIC0xMDQ5LDYgKzEwNDks
MjkgQEAgc3RhdGljIGNoYXIgKmdhdGhlcl9vcHRpb25zKGNoYXIgKmFyZ3ZbXSkKIAlyZXR1cm4g
b3B0c3RyaW5nOwogfQogCisvKiBDaGVjayB3aGV0aGVyIGEgbW9kdWxlIGlzIGJ1aWx0IGludG8g
dGhlIGtlcm5lbCAqLworc3RhdGljIGludCBpc19idWlsdGluKGNvbnN0IGNoYXIgKm1vZG5hbWUs
IGNvbnN0IGNoYXIgKmRpcm5hbWUpCit7CisJY2hhciAqZmlsZW5hbWU7CisJRklMRSAqZmlsZTsK
KwljaGFyICpsaW5lOworCWludCBmb3VuZCA9IDA7CisKKwlub2ZhaWxfYXNwcmludGYoJmZpbGVu
YW1lLCAiJXMvbW9kdWxlcy5idWlsdGluIiwgZGlybmFtZSk7CisJZmlsZSA9IGZvcGVuKGZpbGVu
YW1lLCAiciIpOworCWlmIChmaWxlKSB7CisJCXdoaWxlICgobGluZSA9IGdldGxpbmVfd3JhcHBl
ZChmaWxlLCBOVUxMKSkgIT0gTlVMTCAmJiAhZm91bmQpIHsKKwkJCWNoYXIgKnAgPSBsaW5lOwor
CQkJY2hhciAqYnVpbHRpbiA9IHVuZGVyc2NvcmVzKHN0cnNlcF9za2lwc3BhY2UoJnAsICJcdCAi
KSk7CisJCQlmb3VuZCA9IHN0cmVxKG1vZG5hbWUsIGJ1aWx0aW4pOworCQkJZnJlZShsaW5lKTsK
KwkJfQorCQlmY2xvc2UoZmlsZSk7CisJfQorCWZyZWUoZmlsZW5hbWUpOworCXJldHVybiBmb3Vu
ZDsKK30KKwogLyogRG8gYW4gaW5zdGFsbC9yZW1vdmUgY29tbWFuZDogcmVwbGFjZSAkQ01ETElO
RV9PUFRTIGlmIGl0J3Mgc3BlY2lmaWVkLiAqLwogc3RhdGljIHZvaWQgZG9fY29tbWFuZChjb25z
dCBjaGFyICptb2RuYW1lLAogCQkgICAgICAgY29uc3QgY2hhciAqY29tbWFuZCwKQEAgLTEyNTYs
NiArMTI3OSw3IEBAIHN0YXRpYyBpbnQgaGFuZGxlX21vZHVsZShjb25zdCBjaGFyICptb2RuYW1l
LAogCQkJICBzdHJ1Y3QgbW9kdWxlX29wdGlvbnMgKm1vZG9wdGlvbnMsCiAJCQkgIHN0cnVjdCBt
b2R1bGVfY29tbWFuZCAqY29tbWFuZHMsCiAJCQkgIGNvbnN0IGNoYXIgKmNtZGxpbmVfb3B0cywK
KwkJCSAgY29uc3QgY2hhciAqZGlybmFtZSwKIAkJCSAgZXJyZm5fdCBlcnJvciwKIAkJCSAgbW9k
cHJvYmVfZmxhZ3NfdCBmbGFncykKIHsKQEAgLTEyNzEsNiArMTI5NSwxMSBAQCBzdGF0aWMgaW50
IGhhbmRsZV9tb2R1bGUoY29uc3QgY2hhciAqbW9kbmFtZSwKIAkJCXJldHVybiAwOwogCQl9CiAK
KwkJaWYgKGlzX2J1aWx0aW4obW9kbmFtZSwgZGlybmFtZSkpIHsKKwkJCXdhcm4oIk1vZHVsZSAl
cyBpcyBidWlsdCBpbnRvIHRoZSBrZXJuZWwuXG4iLCBtb2RuYW1lKTsKKwkJCXJldHVybiAwOwor
CQl9CisKIAkJaWYgKCFxdWlldCkKIAkJCWVycm9yKCJNb2R1bGUgJXMgbm90IGZvdW5kLlxuIiwg
bW9kbmFtZSk7CiAJCXJldHVybiAxOwpAQCAtMTM1MCw3ICsxMzc5LDcgQEAgaW50IGRvX21vZHBy
b2JlKGNoYXIgKm1vZG5hbWUsCiAJCQlyZWFkX2RlcGVuZHMoZGlybmFtZSwgYWxpYXNlcy0+bW9k
dWxlLCAmbGlzdCk7CiAJCQlmYWlsZWQgfD0gaGFuZGxlX21vZHVsZShhbGlhc2VzLT5tb2R1bGUs
CiAJCQkJJmxpc3QsIG5ld25hbWUsIG9wdHMsIG1vZG9wdGlvbnMsCi0JCQkJY29tbWFuZHMsIGNt
ZGxpbmVfb3B0cywgZXJyLCBmbGFncyk7CisJCQkJY29tbWFuZHMsIGNtZGxpbmVfb3B0cywgZGly
bmFtZSwgZXJyLCBmbGFncyk7CiAKIAkJCWFsaWFzZXMgPSBhbGlhc2VzLT5uZXh0OwogCQkJSU5J
VF9MSVNUX0hFQUQoJmxpc3QpOwpAQCAtMTM2MSw3ICsxMzkwLDggQEAgaW50IGRvX21vZHByb2Jl
KGNoYXIgKm1vZG5hbWUsCiAJCQlyZXR1cm4gZmFpbGVkOwogCiAJCWZhaWxlZCB8PSBoYW5kbGVf
bW9kdWxlKG1vZG5hbWUsICZsaXN0LCBuZXduYW1lLCBjbWRsaW5lX29wdHMsCi0JCQltb2RvcHRp
b25zLCBjb21tYW5kcywgY21kbGluZV9vcHRzLCBlcnJvciwgZmxhZ3MpOworCQkJbW9kb3B0aW9u
cywgY29tbWFuZHMsIGNtZGxpbmVfb3B0cywgZGlybmFtZSwgZXJyb3IsCisJCQlmbGFncyk7CiAJ
fQogCXJldHVybiBmYWlsZWQ7CiB9Ci0tIAoxLjYuMC40Cgo=
--0016369fa30ba9f7c4046ec26200--
