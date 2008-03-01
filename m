Return-Path: <linux-kernel-owner+w=401wt.eu-S1761901AbYCAAK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761901AbYCAAK2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 19:10:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751283AbYCAAKN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 19:10:13 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:60797 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286AbYCAAKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 19:10:12 -0500
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: [PATCH] CodingStyle: multiple updates
To: Krzysztof Halasa <khc@pm.waw.pl>,
       Richard Knutsson <ricknu-0@student.ltu.se>, SL Baur <steve@xemacs.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       Jan Engelhardt <jengelh@computergmbh.de>, bhalevy.lists@gmail.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Reply-To: 7eggert@gmx.de
Date: Sat, 01 Mar 2008 01:10:02 +0100
References: <a1fQN-352-63@gated-at.bofh.it> <a1g0n-3hn-17@gated-at.bofh.it> <a1h64-5gC-25@gated-at.bofh.it> <a1hII-67t-5@gated-at.bofh.it> <a1hSu-6j3-13@gated-at.bofh.it> <a1iOy-7Mq-37@gated-at.bofh.it> <a1nbp-6hE-5@gated-at.bofh.it> <a1CDx-5ZM-9@gated-at.bofh.it> <a1EFk-Mt-9@gated-at.bofh.it> <a1Yl9-6NF-161@gated-at.bofh.it> <a2m3J-2EX-19@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <E1JVFIg-0001IE-Sf@be1.7eggert.dyndns.org>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX1/P+rqlwPXwiU4mgd2/O0x+wUXSmrHFoqWUIbX
 T3PKKFX/AouYojxDqVhSv9U+W6Euy4vwNxel3v4+tTpfopRCka
 j3a5FSH3cEgZS7nwixiLg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Krzysztof Halasa <khc@pm.waw.pl> wrote:
> Richard Knutsson <ricknu-0@student.ltu.se> writes:

>> In those cases, an only-used-as-indent-character is most preferable.
> 
> It is. The problem is that the editors can't do it (yet?). Or am I
> mistaken?

joe/jstar can, by keeping the whitespace from the previous line.

