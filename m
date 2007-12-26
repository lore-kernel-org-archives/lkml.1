Return-Path: <linux-kernel-owner+w=401wt.eu-S1751909AbXLZJon@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751909AbXLZJon (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 04:44:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751370AbXLZJoe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 04:44:34 -0500
Received: from an-out-0708.google.com ([209.85.132.245]:4106 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353AbXLZJod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 04:44:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type;
        b=rSXQ56S+D76OO0QkIYnUxDZl8oE0lF9JboSJhf3NO58AkP67oXxNm1L/AVEgIsexVmDCIWbUehg4wgXaKrYVIVuvmMe9QyCsrosojWFSmBCQkR1082xDR/e4tSoBfhBoS/sRZf9vsDYO21zLw/NONOSH/ivlbrbg0eXHe6qAz88=
Message-ID: <9cde8bff0712260144t71eb437bxa7394692700cf8cb@mail.gmail.com>
Date: Wed, 26 Dec 2007 18:44:31 +0900
From: "Nguyen Anh Quynh" <aquynh@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, "Andrew Morton" <akpm@osdl.org>,
       tpmdd-devel@lists.sourceforge.net
Subject: [PATCH] tpm_bios.c
Cc: munetoh <munetoh@jp.ibm.com>, "Kuniyasu Suzaki" <k.suzaki@aist.go.jp>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_11878_17738218.1198662271141"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_11878_17738218.1198662271141
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

This trivial patch removes some unused stuffs from tpm_bios.c (against
2.6.24-rc6)

Signed-off-by: Nguyen Anh Quynh <aquynh@gmail.com>

------=_Part_11878_17738218.1198662271141
Content-Type: text/x-patch; name=tpm.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fanohdrk0
Content-Disposition: attachment; filename=tpm.patch

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvY2hhci90cG0vdHBtX2Jpb3MuYyBiL2RyaXZlcnMvY2hhci90
cG0vdHBtX2Jpb3MuYwppbmRleCA2MGEyZDI2Li4wOWJiOTVhIDEwMDY0NAotLS0gYS9kcml2ZXJz
L2NoYXIvdHBtL3RwbV9iaW9zLmMKKysrIGIvZHJpdmVycy9jaGFyL3RwbS90cG1fYmlvcy5jCkBA
IC0yNyw5ICsyNyw3IEBACiAjaW5jbHVkZSA8YWNwaS9hY3RibC5oPgogI2luY2x1ZGUgInRwbS5o
IgogCi0jZGVmaW5lIFRDR19FVkVOVF9OQU1FX0xFTl9NQVgJMjU1CiAjZGVmaW5lIE1BWF9URVhU
X0VWRU5UCQkxMDAwCS8qIE1heCBldmVudCBzdHJpbmcgbGVuZ3RoICovCi0jZGVmaW5lIEFDUElf
VENQQV9TSUcJCSJUQ1BBIgkvKiAweDQxNTA0MzU0IC8nVENQQScgKi8KIAogZW51bSBiaW9zX3Bs
YXRmb3JtX2NsYXNzIHsKIAlCSU9TX0NMSUVOVCA9IDB4MDAsCg==
------=_Part_11878_17738218.1198662271141--
