Return-Path: <linux-kernel-owner+w=401wt.eu-S1751848AbYJTGIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751848AbYJTGIR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 02:08:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751011AbYJTGIE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 02:08:04 -0400
Received: from relay2.globalproof.net ([194.146.153.25]:44727 "EHLO
	relay2.globalproof.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976AbYJTGID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 02:08:03 -0400
From: Denys Fedoryshchenko <denys@visp.net.lb>
Organization: Virtual ISP
To: linux-kernel@vger.kernel.org
Subject: Re: [RFC] Kernel version numbering scheme change
Date: Mon, 20 Oct 2008 09:05:01 +0300
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810200905.01322.denys@visp.net.lb>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let me post my stupid idea :-) Dont hit me :-)

releasenum.branch.subreleasename(chars)+subreleasenumber(numbers).deepersubreleasename.....

1.vanilla.pre3
1.vanilla.rc1
1.vanilla.0 (stable release)
1.vanilla.fix1 (first stable patch)
2.mm.rc5
2.netdev.git2342424323423423

current versions, let's start from 2.6.27 looks like
2627.vanilla.0

next will be 2628


It is easy to parse, easy to find out what is a "base" release number, for 
patches and other trees

for mm's, for example, based on unstable kernels
mm.2.rc5.mm2
easy to understand, that it is mm branch, based on stable release 2, release 
candidate 5, mm patchset N2

Since Linus told there is no need in 2.6, probably there is no reason to keep 
even this numbers.
