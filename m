Return-Path: <linux-kernel-owner+w=401wt.eu-S1756518AbYFZKST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756518AbYFZKST (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 06:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753652AbYFZKSE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 06:18:04 -0400
Received: from ns1.bluetone.cz ([212.158.128.13]:36418 "EHLO ns1.bluetone.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753031AbYFZKSC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 06:18:02 -0400
X-Greylist: delayed 8509 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 Jun 2008 06:18:01 EDT
Message-ID: <48634BA7.6030902@slax.org>
Date: Thu, 26 Jun 2008 09:56:23 +0200
From: Tomas M <tomas@slax.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: LZMA compression algorithm in Kernel - any chance to allow it?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.
I can see the 2.6.25 kernel includes LZO compression algorithm in:

[*] Cryptographic API
 < > LZO compression algorithm

As far as I could see, there was a strong pressure against putting compression algorithms in kernel. Does this LZO example mean that kernel people are now more open to include other algorithms as well? I'd like to include LZMA algo, which has far better compression ratio then anything else widely used today, and is already used in many small or embeded systems (as external patches to kernel or userspace utilities)

If I (or anybody else) submit LZMA code for inclusion in kernel, would you ACCEPT IT ?? (assuming the code looks nice to you)


Thank you

Tomas M
