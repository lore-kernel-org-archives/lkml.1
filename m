Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754179Ab0BHHfH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 02:35:07 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:55399 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100Ab0BHHfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 02:35:05 -0500
Message-ID: <4B6FBEA3.7050803@linux.vnet.ibm.com>
Date: Mon, 08 Feb 2010 13:04:59 +0530
From: Rishikesh <risrajak@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: subrata@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
CC: Balbir Singh <balbir@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, svishuku@in.ibm.com,
       "paul.larson" <paul.larson@ubuntu.com>,
       Garrett Cooper <yanegomi@gmail.com>, Mike Frysinger <vapier@gentoo.org>,
       Robbie Williamson <robbie@ubuntu.com>,
       "manoj.iyer" <manoj.iyer@ubuntu.com>, Nathan Straz <nstraz@redhat.com>,
       Michael Reed <mreed10@us.ibm.com>, Sudarshan Rao <rsudarsh@in.ibm.com>
Subject: Re: [PATCH]: Changed in LTP maintainership responsibilities
References: <4B6FAD84.5070804@linux.vnet.ibm.com> <1265613979.4754.16.camel@subratamodak.linux.ibm.com>
In-Reply-To: <1265613979.4754.16.camel@subratamodak.linux.ibm.com>
Content-Type: multipart/mixed;
 boundary="------------060904000906020606000001"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060904000906020606000001
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 02/08/2010 12:56 PM, Subrata Modak wrote:
> +M:     Rishikesh K Rajak<risrajak@linux.vnet.ibm.com>
> +M:	Garrett Cooper<yanegomi@gmail.com>
> +M:     Mike Frysinger<vapier@gentoo.org>
> +M:     Subrata Modak<subrata@linux.vnet.ibm.com>
>    
Sure, Here is the updated patch.

Changed the LTP maintainer responsibities from 2010.

Ref: http://marc.info/?l=ltp-list&m=126502242912536&w=2

Signed-off By : Rishikesh K Rajak <risrajak@linux.vnet.ibm.com>
---
Index: linux-2.6/MAINTAINERS
===================================================================
--- linux-2.6.orig/MAINTAINERS  2010-02-08 11:27:59.000000000 +0530
+++ linux-2.6/MAINTAINERS       2010-02-08 13:03:53.000000000 +0530
@@ -3411,8 +3411,10 @@
  F:     drivers/scsi/sym53c8xx_2/

  LTP (Linux Test Project)
-M:     Subrata Modak <subrata@linux.vnet.ibm.com>
-M:     Mike Frysinger <vapier@gentoo.org>
+M:     Rishikesh K Rajak <risrajak@linux.vnet.ibm.com>
+M:     Garrett Cooper <yanegomi@gmail.com>
+M:     Mike Frysinger <vapier@gentoo.org>
+M:     Subrata Modak <subrata@linux.vnet.ibm.com>
  L:     ltp-list@lists.sourceforge.net (subscribers-only)
  W:     http://ltp.sourceforge.net/
  T:     git git://git.kernel.org/pub/scm/linux/kernel/git/galak/ltp.git


--------------060904000906020606000001
Content-Type: text/plain;
 name="maintainr-changes.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="maintainr-changes.patch"

Q2hhbmdlZCB0aGUgTFRQIG1haW50YWluZXIgcmVzcG9uc2liaXRpZXMgZnJvbSAyMDEwLgoK
UmVmOiBodHRwOi8vbWFyYy5pbmZvLz9sPWx0cC1saXN0Jm09MTI2NTAyMjQyOTEyNTM2Jnc9
MgoKU2lnbmVkLW9mZiBCeSA6IFJpc2hpa2VzaCBLIFJhamFrIDxyaXNyYWpha0BsaW51eC52
bmV0LmlibS5jb20+Ci0tLQpJbmRleDogbGludXgtMi42L01BSU5UQUlORVJTCj09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT0KLS0tIGxpbnV4LTIuNi5vcmlnL01BSU5UQUlORVJTCTIwMTAtMDItMDggMTE6Mjc6
NTkuMDAwMDAwMDAwICswNTMwCisrKyBsaW51eC0yLjYvTUFJTlRBSU5FUlMJMjAxMC0wMi0w
OCAxMzowMzo1My4wMDAwMDAwMDAgKzA1MzAKQEAgLTM0MTEsOCArMzQxMSwxMCBAQAogRjoJ
ZHJpdmVycy9zY3NpL3N5bTUzYzh4eF8yLwogCiBMVFAgKExpbnV4IFRlc3QgUHJvamVjdCkK
LU06CVN1YnJhdGEgTW9kYWsgPHN1YnJhdGFAbGludXgudm5ldC5pYm0uY29tPgotTToJTWlr
ZSBGcnlzaW5nZXIgPHZhcGllckBnZW50b28ub3JnPgorTToJUmlzaGlrZXNoIEsgUmFqYWsg
PHJpc3JhamFrQGxpbnV4LnZuZXQuaWJtLmNvbT4KK006CUdhcnJldHQgQ29vcGVyIDx5YW5l
Z29taUBnbWFpbC5jb20+CitNOiAgICAgTWlrZSBGcnlzaW5nZXIgPHZhcGllckBnZW50b28u
b3JnPgorTTogICAgIFN1YnJhdGEgTW9kYWsgPHN1YnJhdGFAbGludXgudm5ldC5pYm0uY29t
PgogTDoJbHRwLWxpc3RAbGlzdHMuc291cmNlZm9yZ2UubmV0IChzdWJzY3JpYmVycy1vbmx5
KQogVzoJaHR0cDovL2x0cC5zb3VyY2Vmb3JnZS5uZXQvCiBUOglnaXQgZ2l0Oi8vZ2l0Lmtl
cm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L2dhbGFrL2x0cC5naXQK
--------------060904000906020606000001--
