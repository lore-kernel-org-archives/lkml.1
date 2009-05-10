Return-Path: <linux-kernel-owner+w=401wt.eu-S1755509AbZEJHbh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509AbZEJHbh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 03:31:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751612AbZEJHb2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 03:31:28 -0400
Received: from mail-qy0-f129.google.com ([209.85.221.129]:55743 "EHLO
	mail-qy0-f129.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299AbZEJHb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 03:31:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=GFvsQkXPm3OamZBIUL4hXczXJAzJxGhspyk6w8S/zGSPxE82I2LVHpM1t3fGOooUNB
         ENIbUoYYNSpo1OV2rrKc6zrsv8a3hDqCTvLp6z4iQVhnm8uEkaeryp8EUVJ9rJC5ikDZ
         P+FqBnrBirRZecfVCmW+/ub2uwRqfXqcpCLeI=
MIME-Version: 1.0
In-Reply-To: <20090508121739.b58b2d57.akpm@linux-foundation.org>
References: <90b950fc0905062147w4673308ak54b9d8e348c23ad9@mail.gmail.com>
	 <20090508121739.b58b2d57.akpm@linux-foundation.org>
Date: Sun, 10 May 2009 16:31:27 +0900
Message-ID: <90b950fc0905100031xc2d2dfau2cb8e2ac9a3a4ebe@mail.gmail.com>
Subject: Re: [PATCH] Alpha Channel support for Samsung SoC Framebuffer driver.
From: InKi Dae <daeinki@gmail.com>
To: ben-linux@fluff.org, linux-fbdev-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Kyungmin Park <kmpark@infradead.org>
Content-Type: multipart/mixed; boundary=0016364ee2ea871f6f046989d928
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016364ee2ea871f6f046989d928
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

I have modifed the space problem of my patch and then I am sending
this patch modified again.
You can see attached file.

Thank you for your indication, Andrew Morton.

2009/5/9 Andrew Morton <akpm@linux-foundation.org>:
> On Thu, 7 May 2009 13:47:16 +0900
> InKi Dae <daeinki@gmail.com> wrote:
>
>> This patch supports ARGB1888 and ARGB4888 for Samsung SoC Framebuffer
>> driver. (s3c-fb.c)
>
> The patch was hopelessly mangled by your email client - all tabs
> were replaced with single spaces.
>
> Please fix that up then resend. =A0Please cc myself on that resend.
>
> Thanks.
>

--0016364ee2ea871f6f046989d928
Content-Type: application/octet-stream; name="s3c_lcd_alpha.patch"
Content-Disposition: attachment; filename="s3c_lcd_alpha.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fujfa0rf0

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvdmlkZW8vczNjLWZiLmMgYi9kcml2ZXJzL3ZpZGVvL3MzYy1m
Yi5jCmluZGV4IGUwZTc4OTkuLjU1ZDIyOTggMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvdmlkZW8vczNj
LWZiLmMKKysrIGIvZHJpdmVycy92aWRlby9zM2MtZmIuYwpAQCAtMzU4LDkgKzM1OCwxNiBAQCBz
dGF0aWMgaW50IHMzY19mYl9zZXRfcGFyKHN0cnVjdCBmYl9pbmZvICppbmZvKQogCXdyaXRlbChk
YXRhLCByZWdzICsgVklET1NEX0Iod2luX25vKSk7CiAKIAlkYXRhID0gdmFyLT54cmVzICogdmFy
LT55cmVzOworCisJdTMyIG9zZGNfZGF0YSA9IDA7CisKKwlvc2RjX2RhdGEgPSBWSURJU0QxNENf
QUxQSEExX1IoMHhmKSB8CisJCVZJRElTRDE0Q19BTFBIQTFfRygweGYpIHwKKwkJVklESVNEMTRD
X0FMUEhBMV9CKDB4Zik7CisKIAlpZiAoczNjX2ZiX2hhc19vc2RfZCh3aW5fbm8pKSB7CiAJCXdy
aXRlbChkYXRhLCByZWdzICsgVklET1NEX0Qod2luX25vKSk7Ci0JCXdyaXRlbCgwLCByZWdzICsg
VklET1NEX0Mod2luX25vKSk7CisJCXdyaXRlbChvc2RjX2RhdGEsIHJlZ3MgKyBWSURPU0RfQyh3
aW5fbm8pKTsKIAl9IGVsc2UKIAkJd3JpdGVsKGRhdGEsIHJlZ3MgKyBWSURPU0RfQyh3aW5fbm8p
KTsKIApAQCAtNDA5LDggKzQxNiwxMiBAQCBzdGF0aWMgaW50IHMzY19mYl9zZXRfcGFyKHN0cnVj
dCBmYl9pbmZvICppbmZvKQogCQkJCWRhdGEgfD0gV0lOQ09OMV9CUFBNT0RFXzE5QlBQX0ExNjY2
OwogCQkJZWxzZQogCQkJCWRhdGEgfD0gV0lOQ09OMV9CUFBNT0RFXzE4QlBQXzY2NjsKLQkJfSBl
bHNlIGlmICh2YXItPnRyYW5zcC5sZW5ndGggIT0gMCkKLQkJCWRhdGEgfD0gV0lOQ09OMV9CUFBN
T0RFXzI1QlBQX0ExODg4OworCQl9IGVsc2UgaWYgKHZhci0+dHJhbnNwLmxlbmd0aCA9PSAxKQor
CQkJZGF0YSB8PSBXSU5DT04xX0JQUE1PREVfMjVCUFBfQTE4ODgKKwkJCQl8IFdJTkNPTjFfQkxE
X1BJWDsKKwkJZWxzZSBpZiAodmFyLT50cmFuc3AubGVuZ3RoID09IDQpCisJCQlkYXRhIHw9IFdJ
TkNPTjFfQlBQTU9ERV8yOEJQUF9BNDg4OAorCQkJCXwgV0lOQ09OMV9CTERfUElYIHwgV0lOQ09O
MV9BTFBIQV9TRUw7CiAJCWVsc2UKIAkJCWRhdGEgfD0gV0lOQ09OMF9CUFBNT0RFXzI0QlBQXzg4
ODsKIApAQCAtNDE4LDYgKzQyOSwyMCBAQCBzdGF0aWMgaW50IHMzY19mYl9zZXRfcGFyKHN0cnVj
dCBmYl9pbmZvICppbmZvKQogCQlicmVhazsKIAl9CiAKKwkvKiBJdCBoYXMgbm8gY29sb3Iga2V5
IGNvbnRyb2wgcmVnaXN0ZXIgZm9yIHdpbmRvdzAgKi8KKwlpZiAod2luX25vID4gMCkgeworCQl1
MzIga2V5Y29uMF9kYXRhID0gMCwga2V5Y29uMV9kYXRhID0gMDsKKworCQlrZXljb24wX2RhdGEg
PSB+KFd4S0VZQ09OMF9LRVlCTF9FTiB8CisJCQkJV3hLRVlDT04wX0tFWUVOX0YgfAorCQkJCVd4
S0VZQ09OMF9ESVJDT04pIHwgV3hLRVlDT04wX0NPTVBLRVkoMCk7CisKKwkJa2V5Y29uMV9kYXRh
ID0gV3hLRVlDT04xX0NPTFZBTCgweGZmZmZmZik7CisKKwkJd3JpdGVsKGtleWNvbjBfZGF0YSwg
cmVncyArIFd4S0VZQ09OeSh3aW5fbm8tMSwgMCkpOworCQl3cml0ZWwoa2V5Y29uMV9kYXRhLCBy
ZWdzICsgV3hLRVlDT055KHdpbl9uby0xLCAxKSk7CisJfQorCiAJd3JpdGVsKGRhdGEsIHJlZ3Mg
KyBXSU5DT04od2luX25vKSk7CiAJd3JpdGVsKDB4MCwgcmVncyArIFdJTnhNQVAod2luX25vKSk7
CiAK
--0016364ee2ea871f6f046989d928--
