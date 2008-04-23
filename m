Return-Path: <linux-kernel-owner+w=401wt.eu-S1756245AbYDWLhO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756245AbYDWLhO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 07:37:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752151AbYDWLhB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 07:37:01 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:17087 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477AbYDWLhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 07:37:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type;
        b=x8tjYGBeAHEb4dMUTfvjqoJQS6BLDyFgRBKxDpL4Eimtq/pwj0zPDoQuk3z3Y+urhqK6HbmtwupIjx51ixvDhWWhGzup356/ziOjBMsT3Rj22Dbc2BTSbOALxFNC0dxnfqJXlZGxJEEwAdcffuUyrESYALUHlYqRozMSjMtKvJY=
Message-ID: <eb3ff54b0804230436o396f3014w9a116f38a57c58a4@mail.gmail.com>
Date: Wed, 23 Apr 2008 14:36:58 +0300
From: "Rami Rosen" <ramirose@gmail.com>
To: yoshfuji@linux-ipv6.org, netdev@vger.kernel.org,
       "David Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] [IPV6] Remove IFA_GLOBAL definition from include/net/if_inet6.h.
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_13643_23289438.1208950619018"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_13643_23289438.1208950619018
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,
This patches removes IFA_GLOBAL definition from linux/include/net/if_inet6.h
as it is unused.

Regards,
Rami Rosen


Signed-off-by: Rami Rosen <ramirose@gmail.com>

------=_Part_13643_23289438.1208950619018
Content-Type: text/plain; name=patch3.txt
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ffdty0sr0
Content-Disposition: attachment; filename=patch3.txt

ZGlmZiAtLWdpdCBhL2luY2x1ZGUvbmV0L2lmX2luZXQ2LmggYi9pbmNsdWRlL25ldC9pZl9pbmV0
Ni5oCmluZGV4IGIyY2ZjNDkuLmRiNjZjNzkgMTAwNjQ0Ci0tLSBhL2luY2x1ZGUvbmV0L2lmX2lu
ZXQ2LmgKKysrIGIvaW5jbHVkZS9uZXQvaWZfaW5ldDYuaApAQCAtMTQ4LDcgKzE0OCw2IEBAIHN0
cnVjdCBpZmFjYWRkcjYKICNkZWZpbmUJSUZBX0hPU1QJSVBWNl9BRERSX0xPT1BCQUNLCiAjZGVm
aW5lCUlGQV9MSU5LCUlQVjZfQUREUl9MSU5LTE9DQUwKICNkZWZpbmUJSUZBX1NJVEUJSVBWNl9B
RERSX1NJVEVMT0NBTAotI2RlZmluZQlJRkFfR0xPQkFMCTB4MDAwMFUKIAogc3RydWN0IGlwdjZf
ZGV2c3RhdCB7CiAJc3RydWN0IHByb2NfZGlyX2VudHJ5CSpwcm9jX2Rpcl9lbnRyeTsK
------=_Part_13643_23289438.1208950619018--
