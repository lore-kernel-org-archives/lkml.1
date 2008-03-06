Return-Path: <linux-kernel-owner+w=401wt.eu-S932126AbYCFJNz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932126AbYCFJNz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 04:13:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756470AbYCFJNh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 04:13:37 -0500
Received: from rv-out-0910.google.com ([209.85.198.186]:33896 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755409AbYCFJNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 04:13:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type;
        b=rBMhZU0JdIVB1UIzm+Hk1ya1fBsveuJ/ka/YNPpnwqqtWF79BYEazB8djJvchvcFvYqmCkIDwg4EykEYtVDHBTK/qavbPJiRZin/P9Rp2X1T9cJwJoazRL04XQ+nH5ETOP+DcZeQFL6DbO5+SWbdLUamJ1yI1H7PMuHFEHTM2/U=
Message-ID: <86802c440803060113s5b09c8b7w3a9da92ca15eff03@mail.gmail.com>
Date: Thu, 6 Mar 2008 01:13:34 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Andrew Morton" <akpm@linux-foundation.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86_64: show apicid for cpu in proc
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_22247_12605679.1204794814100"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_22247_12605679.1204794814100
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline



------=_Part_22247_12605679.1204794814100
Content-Type: text/x-patch; name=x86_64_show_apicid.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fdh3zyyl0
Content-Disposition: attachment; filename=x86_64_show_apicid.patch

W1BBVENIXSB4ODZfNjQ6IHNob3cgYXBpY2lkIGZvciBjcHUgaW4gcHJvYwoKU2lnbmVkLW9mZi1i
eTogWWluZ2hhaSBMdSA8eWhsdS5rZXJuZWxAZ21haWwuY29tPgoKZGlmZiAtLWdpdCBhL2FyY2gv
eDg2L2tlcm5lbC9jcHUvcHJvYy5jIGIvYXJjaC94ODYva2VybmVsL2NwdS9wcm9jLmMKaW5kZXgg
MTUwNDNhMy4uY2FlZGZlMCAxMDA2NDQKLS0tIGEvYXJjaC94ODYva2VybmVsL2NwdS9wcm9jLmMK
KysrIGIvYXJjaC94ODYva2VybmVsL2NwdS9wcm9jLmMKQEAgLTU5LDYgKzU5LDcgQEAgc3RhdGlj
IHZvaWQgc2hvd19jcHVpbmZvX2NvcmUoc3RydWN0IHNlcV9maWxlICptLCBzdHJ1Y3QgY3B1aW5m
b194ODYgKmMsCiAJCQkgICBjcHVzX3dlaWdodChwZXJfY3B1KGNwdV9jb3JlX21hcCwgY3B1KSkp
OwogCQlzZXFfcHJpbnRmKG0sICJjb3JlIGlkXHRcdDogJWRcbiIsIGMtPmNwdV9jb3JlX2lkKTsK
IAkJc2VxX3ByaW50ZihtLCAiY3B1IGNvcmVzXHQ6ICVkXG4iLCBjLT5ib290ZWRfY29yZXMpOwor
CQlzZXFfcHJpbnRmKG0sICJhcGljaWRcdDogJTAyeFxuIiwgYy0+YXBpY2lkKTsKIAl9CiAjZW5k
aWYKIH0K
------=_Part_22247_12605679.1204794814100--
