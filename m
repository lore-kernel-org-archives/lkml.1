Return-Path: <linux-kernel-owner+w=401wt.eu-S1760693AbXKUI43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760693AbXKUI43 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 03:56:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757515AbXKUI4V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 03:56:21 -0500
Received: from rv-out-0910.google.com ([209.85.198.186]:3066 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753360AbXKUI4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 03:56:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type;
        b=d2/DYStp6IIcUMSYMQYToahTAqx8z9boMaAk4MmBpARFon+oeJzXfagGwDSLev8EhqXqqs7uAFxFh7TbEj5mDXxaLZ+rfpTZOfBhguV/nj0uS21j9EXU8yiPJsYTQlEy4SwSXmRGXCxf89OsyhWlKPxlB9BwjVKVyI9aq/xai+Q=
Message-ID: <aa79d98a0711210056n6cc951atf4c6af5be26c1ed0@mail.gmail.com>
Date: Wed, 21 Nov 2007 11:56:19 +0300
From: "Cyrill Gorcunov" <gorcunov@gmail.com>
To: "Paul Mackerras" <paulus@samba.org>
Subject: [PATCH] PPC: trivial fix of missed increment on counter
Cc: LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_14063_24346185.1195635379944"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_14063_24346185.1195635379944
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

This patch does fix missed increment on counter

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---
Sorry for that nonstandart patch submission - I've only access
to gmail with Internet Explorer on my work. If that is not OK - will resend
the patch today evening with mutt.

------=_Part_14063_24346185.1195635379944
Content-Type: text/plain; name=electra_ide.c-missed-inc.diff
Content-Transfer-Encoding: base64
X-Attachment-Id: f_f99m8glo
Content-Disposition: attachment; filename=electra_ide.c-missed-inc.diff

LS0tIGEvYXJjL3Bvd2VycGMvcGxhdGZvcm1zL3Bhc2VtaS9lbGVjdHJhX2lkZS5jCVR1ZSBOb3Yg
MTMgMDM6MDU6MjQgMjAwNworKysgYi9hcmMvcG93ZXJwYy9wbGF0Zm9ybXMvcGFzZW1pL2VsZWN0
cmFfaWRlLmMJRnJpIE5vdiAxNiAxMDozMjoxMiAyMDA3CkBAIC00Miw3ICs0Miw3IEBACiAJbnAg
PSBvZl9maW5kX2NvbXBhdGlibGVfbm9kZShOVUxMLCAiaWRlIiwgImVsZWN0cmEtaWRlIik7CiAJ
aSA9IDA7CiAKLQl3aGlsZSAobnAgJiYgaSA8IE1BWF9JRlMpIHsKKwl3aGlsZSAobnAgJiYgaSsr
IDwgTUFYX0lGUykgewogCQltZW1zZXQociwgMCwgc2l6ZW9mKHIpKTsKIAogCQkvKiBwYXRhX3Bs
YXRmb3JtIHdhbnRzIHR3byBhZGRyZXNzIHJhbmdlczogb25lIGZvciB0aGUgYmFzZSByZWdpc3Rl
cnMsCg==
------=_Part_14063_24346185.1195635379944--
