Return-Path: <linux-kernel-owner+w=401wt.eu-S1765965AbXGUNwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765965AbXGUNwS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 09:52:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761418AbXGUNwE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 09:52:04 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:33026 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761000AbXGUNwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 09:52:03 -0400
Date: Sat, 21 Jul 2007 07:52:00 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Simon Arlott <simon@fire.lp0.eu>
Cc: Denis Cheng <crquan@gmail.com>, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] run scripts/Lindent on it to match Documentation/CodingStyle
Message-ID: <20070721135200.GQ14791@parisc-linux.org>
References: <1184489571313-git-send-email-crquan@gmail.com> <4699EEA9.6070709@simon.arlott.org.uk> <20070720170743.GF14791@parisc-linux.org> <46A0F282.8070103@simon.arlott.org.uk> <20070720180019.GJ14791@parisc-linux.org> <46A1A375.3020900@simon.arlott.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46A1A375.3020900@simon.arlott.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 21, 2007 at 07:11:01AM +0100, Simon Arlott wrote:
> Changing the code to fix a utility bug is madness. I think it's been
> fixed too...

I just downloaded the source from CVS and it hasn't:

--- test1.c     2007-07-21 09:49:02.000000000 -0400
+++ test2.c     2007-07-21 09:49:12.000000000 -0400
@@ -8,5 +8,4 @@ flibble:
        zero
        one
-       two
        three
 }

Tell you what, why don't you fix it?  Here's how to get the source:
cvs -d:pserver:anonymous@cvs.sv.gnu.org:/sources/diffutils co diffutils

I'm sure you'll figure it out from there.

-- 
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
