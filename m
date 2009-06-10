Return-Path: <linux-kernel-owner+w=401wt.eu-S1757627AbZFJAHj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757627AbZFJAHj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 20:07:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752777AbZFJAHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 20:07:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56497 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108AbZFJAHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 20:07:31 -0400
Message-ID: <4A2EF93E.70807@zytor.com>
Date: Tue, 09 Jun 2009 17:07:26 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Ray Lee <ray-lk@madrabbit.org>, renton@renton.name,
       linux-kernel@vger.kernel.org
Subject: Re: devpts mounts too slowly
References: <20090603142801.GC21646@beaver.vrungel.ru>	<4A26EB18.6060907@zytor.com>	<20090609161945.811cc01f.akpm@linux-foundation.org>	<2c0942db0906091630l1cc79647h8689e9e929ed1bba@mail.gmail.com> <20090609165304.add1a872.akpm@linux-foundation.org>
In-Reply-To: <20090609165304.add1a872.akpm@linux-foundation.org>
Content-Type: multipart/mixed;
 boundary="------------050302000901070002020701"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050302000901070002020701
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Andrew Morton wrote:
> hm, OK.
> 
> I've now mounted 15000 devpts's and still no slowdown is evident.

This is the test script I used; graphing the results is quite interesting.

	-hpa

--------------050302000901070002020701
Content-Type: application/x-shellscript;
 name="test.sh"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="test.sh"

IyEvYmluL3NoCnJvb3Q9L3RtcC9kZXZwdHMKVElNRUZPUk1BVD0nJTNTJwpuPTEwMDAwMApm
b3IgYSBpbiBgc2VxIDEgJG5gOyBkbwogIG1rZGlyIC1wICRyb290LyRhL2Rldi9wdHMKICAj
IHRpbWUgbW91bnQgLW4gLWkgLXQgZGV2cHRzIG5vbmUgJHJvb3QvJGEvZGV2L3B0cwogIHRp
bWUgbW91bnQgLW4gLWkgLXQgcmFtZnMgbm9uZSAkcm9vdC8kYS9kZXYvcHRzCmRvbmUKZm9y
IGEgaW4gYHNlcSAxICRuYDsgZG8KICB1bW91bnQgLW4gJHJvb3QvJGEvZGV2L3B0cwpkb25l
CnJtIC1yZiAkcm9vdAo=
--------------050302000901070002020701--
