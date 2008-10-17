Return-Path: <linux-kernel-owner+w=401wt.eu-S1754904AbYJQNto@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754904AbYJQNto (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 09:49:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753855AbYJQNtf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 09:49:35 -0400
Received: from sandeen.net ([209.173.210.139]:31682 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753638AbYJQNtf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 09:49:35 -0400
Message-ID: <48F897ED.1060206@sandeen.net>
Date: Fri, 17 Oct 2008 08:49:33 -0500
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.17 (Macintosh/20080914)
MIME-Version: 1.0
To: Martin Michlmayr <tbm@cyrius.com>, Eric Sandeen <sandeen@sandeen.net>,
       Tobias Frost <tobi@coldtobi.de>, linux-kernel@vger.kernel.org,
       debian-arm@lists.debian.org, xfs@oss.sgi.com
Subject: Re: XFS filesystem corruption on the arm(el) architecture
References: <1222893502.5020.40.camel@moria> <20081002004556.GB30001@disturbed> <48E4213E.9090508@sandeen.net> <20081016212500.GA27228@deprecation.cyrius.com> <48F7BC9F.4080909@sandeen.net> <20081017070109.GA30726@deprecation.cyrius.com> <20081017094615.GT4504@soziologie.ch>
In-Reply-To: <20081017094615.GT4504@soziologie.ch>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gaudenz Steinlin wrote:
> On Fri, Oct 17, 2008 at 09:01:09AM +0200, Martin Michlmayr wrote:
>> * Eric Sandeen <sandeen@sandeen.net> [2008-10-16 17:13]:
>>> So is this a regression?  did it used to work?  If so, when? :)
>> The original report was with 2.6.18 but that was with the old ABI:
>> http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=423562
>> I just installed a 2.6.22 kernel with EABI and I can also trigger
>> the bug.  So it's not a (recent) regression.
> 
> As far as I can remember (I only used old ABI arm) this is not a 
> regression. XFS never worked on arm for me.

Ok; I think there are probably a few problems, so trying to keep them
straight.  I at least had xfs working properly in a qemu arm emulator a
few weeks ago... :)

> If you need tests on old ABI just tell me.
> 

ok, thanks!

-Eric
