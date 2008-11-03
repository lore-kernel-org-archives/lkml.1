Return-Path: <linux-kernel-owner+w=401wt.eu-S1754779AbYKCHJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779AbYKCHJW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 02:09:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752237AbYKCHJO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 02:09:14 -0500
Received: from jenny.ondioline.org ([66.220.1.122]:54110 "EHLO
	jenny.ondioline.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173AbYKCHJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 02:09:13 -0500
X-Greylist: delayed 440 seconds by postgrey-1.27 at vger.kernel.org; Mon, 03 Nov 2008 02:09:13 EST
From: Paul Collins <paul@burly.ondioline.org>
To: benh@kernel.crashing.org
Cc: James Cloos <cloos@jhcloos.com>, linux-fbdev-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       Krzysztof Halasa <khc@pm.waw.pl>
Subject: Re: [Linux-fbdev-devel] radeonfb lockup in .28-rc (bisected)
References: <m31vy1k3ea.fsf@lugabout.jhcloos.org>
	<1225152347.8004.49.camel@pasglop>
	<m3k5bt2hsc.fsf@lugabout.jhcloos.org>
	<1225662539.8004.237.camel@pasglop>
Date: Mon, 03 Nov 2008 20:01:52 +1300
In-Reply-To: <1225662539.8004.237.camel@pasglop> (Benjamin Herrenschmidt's
	message of "Mon, 03 Nov 2008 08:48:59 +1100")
Message-ID: <871vxtthr3.fsf@burly.wgtn.ondioline.org>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt <benh@kernel.crashing.org> writes:
> Now, the problem is ... My second son was just born last wed. so I'm
> pretty unavailable right now. Thus, for .29, I'm tempted to go for the
> simpler approach which is to blacklist M7's from imageblit acceleration.

I am also experiencing this problem on a PowerBook G4 with an M10.

0000:00:10.0 VGA compatible controller [0300]: ATI Technologies Inc RV350 [Mobility Radeon 9600 M10] [1002:4e50]

Here are the fonts I'm using:

        http://ondioline.org/~paul/consolefonts/

-- 
Paul Collins
Wellington, New Zealand

Dag vijandelijk luchtschip de huismeester is dood
