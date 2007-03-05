Return-Path: <linux-kernel-owner+w=401wt.eu-S933617AbXCEV1i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933617AbXCEV1i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 16:27:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933601AbXCEV1h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 16:27:37 -0500
Received: from smtp-out4.libero.it ([212.52.84.46]:41331 "EHLO
	smtp-out4.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933614AbXCEV1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 16:27:31 -0500
X-Scanned: with antispam and antivirus automated system at libero.it
From: "mrkiko" <mrkiko.rs@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: BUG: problems compiling UML
Date: Mon, 05 Mar 2007 12:40:32 +0100
Message-ID: <elmo11730948321025164440876@mmx>
User-Agent: elmo/1.3.0
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org




Yes, I red the relevant documentation but his problem is so easy to reproduce 
that there are no problems:
libc6 version: 2.3.6
Linux version: 2.6.20 (work with 2.6.20.1 also).
Problem:
make all ARCH=um fails always on linking: it seems that a -llibname is missing.
If this report is too stupid, sorry!



-- 
-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: GnuPG v1.2.5 (GNU/Linux)

mQGiBEHmquMRBAD+yrpi3zTrjMd1fwSf4rvUtnGXeaV+Gtcx9XWHehf4b4yZ6Jhb
quwMS3jae7+boA3IXZv5ELqezj3ppQU1ByZy2Idoq/cFmKhJPtf6wog/n757Q2mT
zN+E/SwYBfcUv7DZvecDHi9C7YU9Y+UnfXTFCn15/ahojV2wiCf4oqa8JwCgmJHl
2Wy9zbTN6Ga0fS0p1u89S3MEAM6jxntpf2KrXmfqwu289pUT05Qr5LD8PbeDc1UW
kwfcJqzk2C1flt664PugBVWhhoEoW6JXauHDM56f/CiEKc/SCkZUZ9fUQQGGtOva
SGcy7s2zPX2VwSomdE4X/xiO3qBbOrW+jmT/dzO/hstUZ300XDF5tnX2EL0MZ6B6
tlAUBADopcQCu+8TP/Op9eE3K6uqF1jCkyUwdSqRgtQ44CYiYbXV8e5K/FJIxWE6
yoY5gW7ojX+tFVpoJbVrTYH54k4Xjsm6rm/TK0CenjMt4sQ5bYe0kIhkYQTA2t74
zTzXZzfVvtmoLlItg2MB+ZtlulnmjYQ7xxag/e56hKS8SKWRpLQkRW5yaWNvIE1p
b3NvICh5ZWFoKSA8bXJraWtvQG11dWcuaXQ+iF4EExECAB4FAkHmquMCGwMGCwkI
BwMCAxUCAwMWAgECHgECF4AACgkQMzZHgrIY7BHjWACcCziY7vydKtDjVFyAkTnB
FYCMi1MAoIUiOOWh6nTcrbaiHZIWaDA4ErdguQINBEHmqwwQCAC4OqJ5XGzHhKqu
Ly/HlHr7yFi8eSgQhdoGB2vOhiKQfyQ1H2Cm/oi8i5qoZVkf+w+ExL2y84roOMyd
FmupJlRauWtdv3zRd5D7Lo3XbxC/R1dPDhYZFFUW/3xntNeX6fpXVkQJFA7ftSZP
4/dV5IqWeIP

