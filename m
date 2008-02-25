Return-Path: <linux-kernel-owner+w=401wt.eu-S1760554AbYBYWcg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760554AbYBYWcg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 17:32:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757517AbYBYWc1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 17:32:27 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:15339 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757075AbYBYWcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 17:32:25 -0500
Date: Mon, 25 Feb 2008 14:30:48 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: linux-next: Tree for Feb 24
Message-Id: <20080225143048.a67c275f.randy.dunlap@oracle.com>
In-Reply-To: <Pine.LNX.4.64.0802252252070.5158@anakin>
References: <20080224162309.3e67dd22.sfr@canb.auug.org.au>
	<Pine.LNX.4.64.0802252252070.5158@anakin>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="Multipart=_Mon__25_Feb_2008_14_30_48_-0800_mF2R.J4EVkd+Rctz"
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

--Multipart=_Mon__25_Feb_2008_14_30_48_-0800_mF2R.J4EVkd+Rctz
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 25 Feb 2008 22:56:04 +0100 (CET) Geert Uytterhoeven wrote:

> P.S. For the interested, a script to update the SHA1 in the quilt series file:

Thanks, anakin.
Version to update $BASE based on current kernel tree is attached.

---
~Randy

--Multipart=_Mon__25_Feb_2008_14_30_48_-0800_mF2R.J4EVkd+Rctz
Content-Type: application/octet-stream;
 name="quilt-update-tree-base"
Content-Disposition: attachment;
 filename="quilt-update-tree-base"
Content-Transfer-Encoding: base64

IyEvYmluL2Jhc2gKc2VyaWVzPXBhdGNoZXMvc2VyaWVzCgpnZXRfa3ZlcnNpb24oKSB7CmhlYWQg
LTQgTWFrZWZpbGUgfCBzZWQgLWUgJ3MvIC8vZycgPiAvdG1wLy5rdmVyc2lvbi4kJAouIC90bXAv
Lmt2ZXJzaW9uLiQkCnJtIC90bXAvLmt2ZXJzaW9uLiQkCgpjYXNlICIkRVhUUkFWRVJTSU9OIiBp
bgoJIiIpCgkJOzsKCSotbW0qKQoJCUVYVFJBVkVSU0lPTj0kKGVjaG8gIiRFWFRSQVZFUlNJT04i
IHwgc2VkIC1lICdzL1woLipcKS1tbVswLTldKi9cMS8nKQoJCTs7CgkqLWtqKikKCQlFWFRSQVZF
UlNJT049JChlY2hvICIkRVhUUkFWRVJTSU9OIiB8IHNlZCAtZSAncy9cKC4qXCkta2pbMC05XSov
XDEvJykKCQk7OwoJLSopCgkJOzsKCSopCgkJRVhUUkFWRVJTSU9OPSItJEVYVFJBVkVSU0lPTiI7
Owplc2FjCmt2ZXJzaW9uPSRWRVJTSU9OLiRQQVRDSExFVkVMLiRTVUJMRVZFTCRFWFRSQVZFUlNJ
T04KaWYgWyAiJGt2ZXJzaW9uIiA9ICIuLiIgXQp0aGVuCglrdmVyc2lvbj0kKGJhc2VuYW1lICQo
L2Jpbi9wd2QpKQpmaQplY2hvICRrdmVyc2lvbgp9CgppZiBbICEgLWYgJHNlcmllcyBdOyB0aGVu
CiAgICBlY2hvIENhbm5vdCBmaW5kICRzZXJpZXMKICAgIGV4aXQgMQpmaQoKdmVyPWBnZXRfa3Zl
cnNpb25gCmlmIFsgLW4gIiR2ZXIiIF07IHRoZW4KICAgIGlmIGdyZXAgJ14jIEJBU0UnICRzZXJp
ZXMgPiAvZGV2L251bGw7IHRoZW4KCXNlZCAtaSAtZSAicy9eIyBCQVNFLiokLyMgQkFTRSAkdmVy
LyIgJHNlcmllcwoJZWNobyBVcGRhdGVkIEJBU0UgdG8gJHZlcgogICAgZWxzZQoJZWNobyBObyBC
QVNFIGZvdW5kCiAgICBmaQpmaQo=

--Multipart=_Mon__25_Feb_2008_14_30_48_-0800_mF2R.J4EVkd+Rctz--
