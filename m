Return-Path: <linux-kernel-owner+w=401wt.eu-S1762704AbYEGUqx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762704AbYEGUqx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 16:46:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752424AbYEGUqe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 16:46:34 -0400
Received: from smtp2-g19.free.fr ([212.27.42.28]:57494 "EHLO smtp2-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761127AbYEGUqc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 16:46:32 -0400
Message-ID: <48221526.2020305@free.fr>
Date: Wed, 07 May 2008 22:46:30 +0200
From: matthieu castet <castet.matthieu@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.13) Gecko/20080313 Iceape/1.1.9 (Debian-1.1.9-3)
MIME-Version: 1.0
To: Linux Kernel list <linux-kernel@vger.kernel.org>
CC: Yinghai Lu <yhlu.kernel@gmail.com>, Rene Herman <rene.herman@keyaccess.nl>
Subject: Re: 2.6.26, PAT and AMD family 6
References: <482214B8.9030308@free.fr>
In-Reply-To: <482214B8.9030308@free.fr>
Content-Type: multipart/mixed;
 boundary="------------070501070404000501020409"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070501070404000501020409
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

matthieu castet wrote:
>> -- Why does this thing hide the fact that my CPU does have PAT from
>>    me (even though it might elect to not trust it)?
> 
> Attach a trivial (untested) patch that should let know that PAT was 
> disabled by kernel.
> 
This one should be better
> Matthieu
> 
> PS : if you want more tester you should print in this message a link of 
> what should be tested to know if PAT is broken in this machine and where 
> to report it.
> 


--------------070501070404000501020409
Content-Type: text/plain;
 name="pat_infp2"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="pat_infp2"

ZGlmZiAtLWdpdCBhL2FyY2gveDg2L2tlcm5lbC9jcHUvY29tbW9uLmMgYi9hcmNoL3g4Ni9r
ZXJuZWwvY3B1L2NvbW1vbi5jCmluZGV4IDM1YjRmNmEuLjI3YmU4YzIgMTAwNjQ0Ci0tLSBh
L2FyY2gveDg2L2tlcm5lbC9jcHUvY29tbW9uLmMKKysrIGIvYXJjaC94ODYva2VybmVsL2Nw
dS9jb21tb24uYwpAQCAtMjg2LDYgKzI4Niw3IEBAIHN0YXRpYyB2b2lkIF9fY3B1aW5pdCBl
YXJseV9nZXRfY2FwKHN0cnVjdCBjcHVpbmZvX3g4NiAqYykKIHsKIAl1MzIgdGZtcywgeGx2
bDsKIAl1bnNpZ25lZCBpbnQgZWJ4OworCWludCBwYXQ7CiAKIAltZW1zZXQoJmMtPng4Nl9j
YXBhYmlsaXR5LCAwLCBzaXplb2YgYy0+eDg2X2NhcGFiaWxpdHkpOwogCWlmIChoYXZlX2Nw
dWlkX3AoKSkgewpAQCAtMzA4LDYgKzMwOSw3IEBAIHN0YXRpYyB2b2lkIF9fY3B1aW5pdCBl
YXJseV9nZXRfY2FwKHN0cnVjdCBjcHVpbmZvX3g4NiAqYykKIAogCX0KIAorCXBhdCA9IGNw
dV9oYXMoYywgWDg2X0ZFQVRVUkVfUEFUKTsKIAljbGVhcl9jcHVfY2FwKGMsIFg4Nl9GRUFU
VVJFX1BBVCk7CiAKIAlzd2l0Y2ggKGMtPng4Nl92ZW5kb3IpIHsKQEAgLTMyMCw2ICszMjIs
OCBAQCBzdGF0aWMgdm9pZCBfX2NwdWluaXQgZWFybHlfZ2V0X2NhcChzdHJ1Y3QgY3B1aW5m
b194ODYgKmMpCiAJCQlzZXRfY3B1X2NhcChjLCBYODZfRkVBVFVSRV9QQVQpOwogCQlicmVh
azsKIAl9CisJaWYgKHBhdCAhPSBjcHVfaGFzKGMsIFg4Nl9GRUFUVVJFX1BBVCkpCisJCXBy
aW50ayhLRVJOX0lORk8gIlBBVCBzdXBwb3J0IGRpc2FibGVkIik7CiAKIH0KIAo=
--------------070501070404000501020409--
