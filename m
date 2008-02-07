Return-Path: <linux-kernel-owner+w=401wt.eu-S1757997AbYBGQYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757997AbYBGQYT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 11:24:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755135AbYBGQYF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 11:24:05 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:15935 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755104AbYBGQYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 11:24:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type;
        b=TF6NsyCdsaoZymP0X0RCRhB+6zKmC4IT0ryvgE6SZFq5ZmPQ3MkjNld0jugAUs+ah7wxU1EIYpeUUwr/UT1klL+S9vyxQOUO5hzgM4FFxhbylhY3sayb3lR3ewI/+TC4IZVzlZiUP4vlfx5lMQHSMF40HmicjOddrJbj+5dYIss=
Message-ID: <eb3ff54b0802070823y7038fcedga27cba4a9bb35731@mail.gmail.com>
Date: Thu, 7 Feb 2008 18:23:58 +0200
From: "Rami Rosen" <ramirose@gmail.com>
To: "David Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH] [IPV6] Minor cleanup: remove unused definitions in net/ip6_fib.h
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_12950_13255778.1202401438335"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_12950_13255778.1202401438335
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

This patch removes some unused definitions and one method typedef
declaration (f_pnode)
in include/net/ip6_fib.h, as they are not used in the kernel.

Regards,
Rami Rosen


Signed-off-by: Rami Rosen <ramirose@gmail.com>

------=_Part_12950_13255778.1202401438335
Content-Type: text/plain; name=patch.txt
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fcdipq160
Content-Disposition: attachment; filename=patch.txt

ZGlmZiAtLWdpdCBhL2luY2x1ZGUvbmV0L2lwNl9maWIuaCBiL2luY2x1ZGUvbmV0L2lwNl9maWIu
aAppbmRleCBkOGQ4NWIxLi45NTNkNjA0IDEwMDY0NAotLS0gYS9pbmNsdWRlL25ldC9pcDZfZmli
LmgKKysrIGIvaW5jbHVkZS9uZXQvaXA2X2ZpYi5oCkBAIC0xNTAsMTkgKzE1MCw2IEBAIHN0cnVj
dCBydDZfc3RhdGlzdGljcyB7CiAgKgogICovCiAKLSNkZWZpbmUgUlRQUklfRklSRVdBTEwJOAkJ
LyogRmlyZXdhbGwgY29udHJvbCBpbmZvcm1hdGlvbgkqLwotI2RlZmluZSBSVFBSSV9GTE9XCTE2
CQkvKiBGbG93IGJhc2VkIGZvcndhcmRpbmcgcnVsZXMJKi8KLSNkZWZpbmUgUlRQUklfS0VSTl9D
VEwJMzIJCS8qIEtlcm5lbCBjb250cm9sIHJvdXRlcwkqLwotCi0jZGVmaW5lIFJUUFJJX1VTRVJf
TUlOCTI1NgkJLyogTWltaW11bSB1c2VyIHByaW9yaXR5CSovCi0jZGVmaW5lIFJUUFJJX1VTRVJf
TUFYCTEwMjQJCS8qIE1heGltdW0gdXNlciBwcmlvcml0eQkqLwotCi0jZGVmaW5lIFJUUFJJX0tF
Uk5fREZMVAk0MDk2CQkvKiBLZXJuZWwgZGVmYXVsdCByb3V0ZXMJKi8KLQotI2RlZmluZQlNQVhf
RkxPV19CQUNLVFJBQ0UJMzIKLQotCi10eXBlZGVmIHZvaWQJCQkoKmZfcG5vZGUpKHN0cnVjdCBm
aWI2X25vZGUgKmZuLCB2b2lkICopOwogCiBzdHJ1Y3QgZmliNl90YWJsZSB7CiAJc3RydWN0IGhs
aXN0X25vZGUJdGI2X2hsaXN0Owo=
------=_Part_12950_13255778.1202401438335--
