Return-Path: <linux-kernel-owner+w=401wt.eu-S1756371AbYKEK2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756371AbYKEK2T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 05:28:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754584AbYKEK2H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 05:28:07 -0500
Received: from jenny.ondioline.org ([66.220.1.122]:59513 "EHLO
	jenny.ondioline.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754164AbYKEK2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 05:28:06 -0500
From: Paul Collins <paul@burly.ondioline.org>
To: benh@kernel.crashing.org
Cc: linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       James Cloos <cloos@jhcloos.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       Krzysztof Halasa <khc@pm.waw.pl>
Subject: Re: [Linux-fbdev-devel] radeonfb lockup in .28-rc (bisected)
References: <m31vy1k3ea.fsf@lugabout.jhcloos.org>
	<1225152347.8004.49.camel@pasglop>
	<m3k5bt2hsc.fsf@lugabout.jhcloos.org>
	<1225662539.8004.237.camel@pasglop>
	<871vxtthr3.fsf@burly.wgtn.ondioline.org>
	<1225874361.13603.12.camel@pasglop>
Date: Wed, 05 Nov 2008 23:28:01 +1300
In-Reply-To: <1225874361.13603.12.camel@pasglop> (Benjamin Herrenschmidt's
	message of "Wed, 05 Nov 2008 19:39:21 +1100")
Message-ID: <87skq6sc0e.fsf@burly.wgtn.ondioline.org>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt <benh@kernel.crashing.org> writes:

> On Mon, 2008-11-03 at 20:01 +1300, Paul Collins wrote:
>> I am also experiencing this problem on a PowerBook G4 with an M10.
>>
>> 0000:00:10.0 VGA compatible controller [0300]: ATI Technologies Inc RV350 [Mobility Radeon 9600 M10] [1002:4e50]
>> 
>> Here are the fonts I'm using:
>> 
>>         http://ondioline.org/~paul/consolefonts/
>
> For some reason, that font gives me "Bad font file format". 

Odd.  I'm using setfont from Debian's kbd 1.14.1-4 to load it.

P.S. I haven't had time to play with the 32-roundup thing any further yet.

-- 
Paul Collins
Wellington, New Zealand

Dag vijandelijk luchtschip de huismeester is dood
