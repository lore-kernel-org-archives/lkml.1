Return-Path: <linux-kernel-owner+w=401wt.eu-S1757630AbYFBGkb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757630AbYFBGkb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 02:40:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752048AbYFBGkV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 02:40:21 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:59627 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611AbYFBGkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 02:40:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type;
        b=lQ6aGNwoIv6xIx/fiRAdOEV8CNu5TbKJ98RyIQYiigSd3q5nYxRfLJbGlyYD+w2LsBvgm/vJhdQrW4iKNcHqrkQF43M3z5UfMMkk/HXe165QwaRUunV/ZImph6LEXu8yn7TdnfV5qu52wlBAkQaby1yyAX3jkrtqm8Qn6ThzMCo=
Message-ID: <eb3ff54b0806012340v448b8b84p32ab8995e755322e@mail.gmail.com>
Date: Mon, 2 Jun 2008 09:40:19 +0300
From: "Rami Rosen" <ramirose@gmail.com>
To: "David Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH net-2.6 2/2] [IPV4] [NETFILTER] Misc Cleanups.
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_9881_21176922.1212388819609"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_9881_21176922.1212388819609
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

This patch removes nf_ct_ipv4_ct_gather_frags() method declaration from
include/net/netfilter/ipv4/nf_conntrack_ipv4.h, since it is unused in
the Linux kernel.

Regards,
Rami Rosen


Signed-off-by: Rami Rosen <ramirose@gmail.com>

------=_Part_9881_21176922.1212388819609
Content-Type: text/plain; name=patch2.txt
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fgyoxwjg0
Content-Disposition: attachment; filename=patch2.txt

ZGlmZiAtLWdpdCBhL2luY2x1ZGUvbmV0L25ldGZpbHRlci9pcHY0L25mX2Nvbm50cmFja19pcHY0
LmggYi9pbmNsdWRlL25ldC9uZXRmaWx0ZXIvaXB2NC9uZl9jb25udHJhY2tfaXB2NC5oCmluZGV4
IDliZjA1OTguLjc1NzNkNTIgMTAwNjQ0Ci0tLSBhL2luY2x1ZGUvbmV0L25ldGZpbHRlci9pcHY0
L25mX2Nvbm50cmFja19pcHY0LmgKKysrIGIvaW5jbHVkZS9uZXQvbmV0ZmlsdGVyL2lwdjQvbmZf
Y29ubnRyYWNrX2lwdjQuaApAQCAtOSw4ICs5LDYgQEAKICNpZm5kZWYgX05GX0NPTk5UUkFDS19J
UFY0X0gKICNkZWZpbmUgX05GX0NPTk5UUkFDS19JUFY0X0gKIAotLyogUmV0dXJucyBuZXcgc2tf
YnVmZiwgb3IgTlVMTCAqLwotc3RydWN0IHNrX2J1ZmYgKm5mX2N0X2lwdjRfY3RfZ2F0aGVyX2Zy
YWdzKHN0cnVjdCBza19idWZmICpza2IpOwogCiBleHRlcm4gc3RydWN0IG5mX2Nvbm50cmFja19s
M3Byb3RvIG5mX2Nvbm50cmFja19sM3Byb3RvX2lwdjQ7Cgo=
------=_Part_9881_21176922.1212388819609--
