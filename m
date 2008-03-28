Return-Path: <linux-kernel-owner+w=401wt.eu-S1755253AbYC1KYM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253AbYC1KYM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 06:24:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753294AbYC1KX4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 06:23:56 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:25452 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752553AbYC1KXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 06:23:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:mime-version:content-type;
        b=jNv8VopqPw3BainRccGAgt2HNMNdSrfbbhC/DWce0ueSlzGNJgSRB/cw+53gergf0KLsqRvo/88WHGq5gHuooVlxW9TbHlO4D0QfTzR9YDTcvfp/BPA9orTyAvfUgIDnsIt/1D/zZRRxW6UIvrBOsvXB6ulRvQldNm5vbKYTI68=
Message-ID: <eb3ff54b0803280323w3b87f3fdy1ecfdb6424e62795@mail.gmail.com>
Date: Fri, 28 Mar 2008 13:23:53 +0300
From: "Rami Rosen" <ramirose@gmail.com>
To: "David Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH] [net-2.6.26] [IPV6] [CLEANUP] Remove unused method declaration in include/net/addrconf.h.
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_3286_20348528.1206699833583"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_3286_20348528.1206699833583
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,
  This patches removes unused declaration of addrconf_forwarding_on() method
  in include/net/addrconf.h.

Regards,
Rami Rosen


Signed-off-by: Rami Rosen <ramirose@gmail.com>

------=_Part_3286_20348528.1206699833583
Content-Type: text/plain; name=patch.txt
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fecltz9p0
Content-Disposition: attachment; filename=patch.txt

ZGlmZiAtLWdpdCBhL2luY2x1ZGUvbmV0L2FkZHJjb25mLmggYi9pbmNsdWRlL25ldC9hZGRyY29u
Zi5oCmluZGV4IGQwYzQ3YzMuLmQ4OWIwYmMgMTAwNjQ0Ci0tLSBhL2luY2x1ZGUvbmV0L2FkZHJj
b25mLmgKKysrIGIvaW5jbHVkZS9uZXQvYWRkcmNvbmYuaApAQCAtMTg1LDcgKzE4NSw2IEBAIHN0
YXRpYyBpbmxpbmUgdm9pZCBpbjZfaWZhX3B1dChzdHJ1Y3QgaW5ldDZfaWZhZGRyICppZnApCiAj
ZGVmaW5lIGluNl9pZmFfaG9sZChpZnApCWF0b21pY19pbmMoJihpZnApLT5yZWZjbnQpCiAKIAot
ZXh0ZXJuIHZvaWQJCQlhZGRyY29uZl9mb3J3YXJkaW5nX29uKHZvaWQpOwogLyoKICAqCUhhc2gg
ZnVuY3Rpb24gdGFrZW4gZnJvbSBuZXRfYWxpYXMuYwogICovCg==
------=_Part_3286_20348528.1206699833583--
