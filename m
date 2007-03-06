Return-Path: <linux-kernel-owner+w=401wt.eu-S933565AbXCFAHv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933565AbXCFAHv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 19:07:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933575AbXCFAHv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 19:07:51 -0500
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:46545 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933565AbXCFAHu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 19:07:50 -0500
Date: Tue, 6 Mar 2007 00:07:46 +0000
From: Ken Moffat <zarniwhoop@ntlworld.com>
To: francesco foresti <frafore@tiscali.it>
Cc: linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: 2.6.20-1 not working on ibook g4 (BUG/Oops)
Message-ID: <20070306000746.GA20438@deepthought>
References: <200703051659.56245.frafore@tiscali.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <200703051659.56245.frafore@tiscali.it>
User-Agent: Mutt/1.5.12-2006-07-14
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 05, 2007 at 04:59:35PM +0100, francesco foresti wrote:
> Hi,
> I have to correct myself:
> 2.6.19-7 just freezes randomly. At this point, the last surely working kernel 
> i am aware of is 2.6.18, built from debian sources. Actually i'm trying 
> (for the very first time) to git-bisect Linus' tree, to see if i can figure 
> out something, but i feel my chances are extremely low.. 
> 
> Best
> -- 
 Sounds like a distro problem.  In particular, distros add patches
and use different configs.  My ibook G4 has been running 2.6.20-rc4
since about January 8th without any issues, but I can remember that
it took me a very long time to come up with a .config which worked
for me after the move to arch/powerpc.  If your graphics card is a
radeon, I can send you my .config off-list if you think that will
help.

Ken
-- 
das eine Mal als Tragödie, das andere Mal als Farce
