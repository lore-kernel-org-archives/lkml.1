Return-Path: <linux-kernel-owner+w=401wt.eu-S1753041AbYJQKBr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753041AbYJQKBr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 06:01:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752036AbYJQKBg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 06:01:36 -0400
Received: from ping.pong.ch ([212.103.71.101]:59201 "EHLO ping.pong.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754120AbYJQKBe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 06:01:34 -0400
X-Greylist: delayed 1110 seconds by postgrey-1.27 at vger.kernel.org; Fri, 17 Oct 2008 06:01:34 EDT
Date: Fri, 17 Oct 2008 11:46:15 +0200
From: Gaudenz Steinlin <gaudenz@debian.org>
To: Martin Michlmayr <tbm@cyrius.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, Tobias Frost <tobi@coldtobi.de>,
       linux-kernel@vger.kernel.org, debian-arm@lists.debian.org,
       xfs@oss.sgi.com
Subject: Re: XFS filesystem corruption on the arm(el) architecture
Message-ID: <20081017094615.GT4504@soziologie.ch>
Mail-Followup-To: Martin Michlmayr <tbm@cyrius.com>,
	Eric Sandeen <sandeen@sandeen.net>, Tobias Frost <tobi@coldtobi.de>,
	linux-kernel@vger.kernel.org, debian-arm@lists.debian.org,
	xfs@oss.sgi.com
References: <1222893502.5020.40.camel@moria> <20081002004556.GB30001@disturbed> <48E4213E.9090508@sandeen.net> <20081016212500.GA27228@deprecation.cyrius.com> <48F7BC9F.4080909@sandeen.net> <20081017070109.GA30726@deprecation.cyrius.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081017070109.GA30726@deprecation.cyrius.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 17, 2008 at 09:01:09AM +0200, Martin Michlmayr wrote:
> * Eric Sandeen <sandeen@sandeen.net> [2008-10-16 17:13]:
> > So is this a regression?  did it used to work?  If so, when? :)
> 
> The original report was with 2.6.18 but that was with the old ABI:
> http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=423562
> I just installed a 2.6.22 kernel with EABI and I can also trigger
> the bug.  So it's not a (recent) regression.

As far as I can remember (I only used old ABI arm) this is not a 
regression. XFS never worked on arm for me.

If you need tests on old ABI just tell me.

-- 
Ever tried. Ever failed. No matter.
Try again. Fail again. Fail better.
~ Samuel Beckett ~
