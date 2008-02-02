Return-Path: <linux-kernel-owner+w=401wt.eu-S1764537AbYBBBhp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764537AbYBBBhp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 20:37:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761849AbYBBBe3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 20:34:29 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:28697 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764181AbYBBBeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 20:34:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type;
        b=sLmz+c9iUc+ouk1EVtg/+s6DTu6Y7uvJXMUej8V36N9nNYSE8kDQ6Ygztkd32i3g1oaKw0tUTGe44hSNtfBIhB/WMZX+TOj6v1o8lhUFQoj7B2uHS8r26Tddnz/W9LHrd6AuhtvTzVNTYyvymBsg/9St3CiiXWY11Mi1Cs8kujo=
Message-ID: <6101e8c40802011734l63bdb871r29006ad5af408234@mail.gmail.com>
Date: Sat, 2 Feb 2008 02:34:24 +0100
From: "=?ISO-8859-1?Q?Oliver_Pinter_(Pint=E9r_Oliv=E9r)?=" 
	<oliver.pntr@gmail.com>
To: "Linux Kernel" <linux-kernel@vger.kernel.org>, stable@kernel.org,
       stable-commits@vger.kernel.org
Subject: [2.6.22.y] {12/17} - nfsacl-retval.diff - series for stable kernel #2
Cc: "chrisw@sous-sol.org" <chrisw@sous-sol.org>, "Greg KH" <gregkh@suse.de>,
       "Willy Tarreau" <w@1wt.eu>, "Adrian Bunk" <bunk@kernel.org>,
       Roland <devzero@web.de>, "Andreas Gruenbacher" <agruen@suse.de>,
       "J. Bruce Fields" <bfields@citi.umich.edu>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_26275_17026258.1201916064433"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_26275_17026258.1201916064433
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

mainline: ac8587dcb58e40dd336d99d60f852041e06cc3dd

-- 
Thanks,
Oliver

------=_Part_26275_17026258.1201916064433
Content-Type: text/x-diff; name=nfsacl-retval.diff
Content-Transfer-Encoding: base64
X-Attachment-Id: file0
Content-Disposition: attachment; filename=nfsacl-retval.diff

RnJvbTogSi4gQnJ1Y2UgRmllbGRzIDxiZmllbGRzQGNpdGkudW1pY2guZWR1PgpEYXRlOiBGcmks
IDIgTm92IDIwMDcgMTU6MzY6MDggLTA0MDAKU3ViamVjdDogW1BBVENIXSBrbmZzZDogZml4IHNw
dXJpb3VzIEVJTlZBTCBlcnJvcnMgb24gZmlyc3QgYWNjZXNzIG9mIG5ldyBmaWxlc3lzdGVtClJl
ZmVyZW5jZXM6IDM0MDg3MwoKVGhlIHYyL3YzIGFjbCBjb2RlIGluIG5mc2QgaXMgdHJhbnNsYXRp
bmcgYW55IHJldHVybiBmcm9tIGZoX3ZlcmlmeSgpIHRvCm5mc2Vycl9pbnZhbC4gIFRoaXMgaXMg
cGFydGljdWxhcmx5IHVuZm9ydHVuYXRlIGluIHRoZSBjYXNlIG9mIGFuCm5mc2Vycl9kcm9waXQg
cmV0dXJuLCB3aGljaCBpcyBhbiBpbnRlcm5hbCBlcnJvciBtZWFudCB0byBpbmRpY2F0ZSB0bwpj
YWxsZXJzIHRoYXQgdGhpcyByZXF1ZXN0IGhhcyBiZWVuIGRlZmVycmVkIGFuZCBzaG91bGQganVz
dCBiZSBkcm9wcGVkCnBlbmRpbmcgdGhlIHJlc3VsdHMgb2YgYW4gdXBjYWxsIHRvIG1vdW50ZC4K
ClRoYW5rcyB0byBSb2xhbmQgPGRldnplcm9Ad2ViLmRlPiBmb3IgYnVnIHJlcG9ydCBhbmQgZGF0
YSBjb2xsZWN0aW9uLgoKQ2M6IFJvbGFuZCA8ZGV2emVyb0B3ZWIuZGU+CkFja2VkLWJ5OiBBbmRy
ZWFzIEdydWVuYmFjaGVyIDxhZ3J1ZW5Ac3VzZS5kZT4KU2lnbmVkLW9mZi1ieTogSi4gQnJ1Y2Ug
RmllbGRzIDxiZmllbGRzQGNpdGkudW1pY2guZWR1PgoKSW5kZXg6IGxpbnV4LTIuNi4yMy9mcy9u
ZnNkL25mczJhY2wuYwo9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09Ci0tLSBsaW51eC0yLjYuMjMub3JpZy9mcy9uZnNkL25m
czJhY2wuYworKysgbGludXgtMi42LjIzL2ZzL25mc2QvbmZzMmFjbC5jCkBAIC00MSw3ICs0MSw3
IEBAIHN0YXRpYyBfX2JlMzIgbmZzYWNsZF9wcm9jX2dldGFjbChzdHJ1Y3QKIAogCWZoID0gZmhf
Y29weSgmcmVzcC0+ZmgsICZhcmdwLT5maCk7CiAJaWYgKChuZnNlcnIgPSBmaF92ZXJpZnkocnFz
dHAsICZyZXNwLT5maCwgMCwgTUFZX05PUCkpKQotCQlSRVRVUk5fU1RBVFVTKG5mc2Vycl9pbnZh
bCk7CisJCVJFVFVSTl9TVEFUVVMobmZzZXJyKTsKIAogCWlmIChhcmdwLT5tYXNrICYgfihORlNf
QUNMfE5GU19BQ0xDTlR8TkZTX0RGQUNMfE5GU19ERkFDTENOVCkpCiAJCVJFVFVSTl9TVEFUVVMo
bmZzZXJyX2ludmFsKTsKSW5kZXg6IGxpbnV4LTIuNi4yMy9mcy9uZnNkL25mczNhY2wuYwo9PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09Ci0tLSBsaW51eC0yLjYuMjMub3JpZy9mcy9uZnNkL25mczNhY2wuYworKysgbGludXgt
Mi42LjIzL2ZzL25mc2QvbmZzM2FjbC5jCkBAIC0zNyw3ICszNyw3IEBAIHN0YXRpYyBfX2JlMzIg
bmZzZDNfcHJvY19nZXRhY2woc3RydWN0IHMKIAogCWZoID0gZmhfY29weSgmcmVzcC0+ZmgsICZh
cmdwLT5maCk7CiAJaWYgKChuZnNlcnIgPSBmaF92ZXJpZnkocnFzdHAsICZyZXNwLT5maCwgMCwg
TUFZX05PUCkpKQotCQlSRVRVUk5fU1RBVFVTKG5mc2Vycl9pbnZhbCk7CisJCVJFVFVSTl9TVEFU
VVMobmZzZXJyKTsKIAogCWlmIChhcmdwLT5tYXNrICYgfihORlNfQUNMfE5GU19BQ0xDTlR8TkZT
X0RGQUNMfE5GU19ERkFDTENOVCkpCiAJCVJFVFVSTl9TVEFUVVMobmZzZXJyX2ludmFsKTsK
------=_Part_26275_17026258.1201916064433--
