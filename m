Return-Path: <linux-kernel-owner+w=401wt.eu-S1750755AbXBMPlF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750755AbXBMPlF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 10:41:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750752AbXBMPlF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 10:41:05 -0500
Received: from ns2.tasking.nl ([195.193.207.10]:22776 "EHLO ns2.tasking.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750755AbXBMPlD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 10:41:03 -0500
X-Greylist: delayed 1599 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Feb 2007 10:41:03 EST
To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
X-Newsreader: knews 1.0b.1
Reply-To: dick.streefland@altium.nl (Dick Streefland)
Organization: Altium BV
X-Face: "`*@3nW;mP[=Z(!`?W;}cn~3M5O_/vMjX&Pe!o7y?xi@;wnA&Tvx&kjv'N\P&&5Xqf{2CaT 9HXfUFg}Y/TT^?G1j26Qr[TZY%v-1A<3?zpTYD5E759Q?lEoR*U1oj[.9\yg_o.~O.$wj:t(B+Q_?D XX57?U,#b,iM$[zX'I(!'VCQM)N)x~knSj>M*@l}y9(tK\rYwdv%~+&*jV"epphm>|q~?ys:g:K#R" 2PuAzy-N9cKM<Ml/%yPQxpq"Ttm{GzBn-*:;619QM2HLuRX4]~361+,[uFp6f"JF5R`y
References: <Pine.LNX.4.64.0702081145470.8424@woody.linux-foundation.org> <Pine.LNX.4.61.0702082202180.24888@yvahk01.tjqt.qr> <Pine.LNX.4.64.0702081324090.8424@woody.linux-foundation.org> <Pine.LNX.4.64.0702081432320.27603@chino.kir.corp.google.com> <Pine.LNX.4.64.0702081528070.8424@woody.linux-foundation.org> <Pine.LNX.4.64.0702081554380.29559@chino.kir.corp.google.com> <Pine.LNX.4.64.0702081632200.8424@woody.linux-foundation.org> <Pine.LNX.4.61.0702091330380.31955@yvahk01.tjqt.qr>
From: dick.streefland@altium.nl (Dick Streefland)
Subject: Re: somebody dropped a (warning) bomb
Content-Type: text/plain; charset=us-ascii
NNTP-Posting-Host: 172.17.1.66
Message-ID: <27c8.45d1d5cf.69f9a@altium.nl>
Date: Tue, 13 Feb 2007 15:14:23 -0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt <jengelh@linux01.gwdg.de> wrote:
| Further, giving again answer to the question whether they generate signed or
| unsigned comparisons: Have you ever seen a computer which addresses memory with
| negative numbers? Since the answer is most likely no, signed comparisons would
| not make sense for me.

The Transputer has (had?) a signed address space:

http://maven.smith.edu/~thiebaut/transputer/chapter2/chap2-3.html

-- 
Dick Streefland                      ////                      Altium BV
dick.streefland@altium.nl           (@ @)          http://www.altium.com
--------------------------------oOO--(_)--OOo---------------------------

