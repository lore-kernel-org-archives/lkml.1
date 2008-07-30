Return-Path: <linux-kernel-owner+w=401wt.eu-S1758993AbYG3RJc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758993AbYG3RJc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 13:09:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751511AbYG3RJX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 13:09:23 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:33960 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877AbYG3RJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 13:09:23 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <48909F74.8060702@s5r6.in-berlin.de>
Date: Wed, 30 Jul 2008 19:05:56 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.16) Gecko/20080722 SeaMonkey/1.1.11
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Rene Herman <rene.herman@keyaccess.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jon Smirl <jonsmirl@gmail.com>, Paul Mundt <lethal@linux-sh.org>,
       James Morris <jmorris@namei.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, Dave Jones <davej@redhat.com>,
       Theodore Tso <tytso@mit.edu>, Simon Arlott <simon@fire.lp0.eu>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: 463 kernel developers missing!
References: <Xine.LNX.4.64.0807290751510.31732@us.intercode.com.au> <20080728234131.GD28055@linux-sh.org> <9e4733910807281714h2918fcbey77c8d1cea902a3fd@mail.gmail.com> <488E644D.7000507@keyaccess.nl> <9e4733910807281750p52cf150lacd0e237732046e7@mail.gmail.com> <488EF377.5080603@keyaccess.nl> <20080730072448.GB1564@cs181140183.pp.htv.fi> <4890284E.3050806@s5r6.in-berlin.de> <20080730124650.GB19966@cs181140183.pp.htv.fi> <4890646D.3060000@keyaccess.nl> <20080730153247.GA21597@cs181140183.pp.htv.fi>
In-Reply-To: <20080730153247.GA21597@cs181140183.pp.htv.fi>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Wed, Jul 30, 2008 at 02:54:05PM +0200, Rene Herman wrote:
>> You only certify anything when _you_ put your address in. Given that  
>> it's a very common occurence that not you but _others_ do, this does not  
>> mean a _single_ thing. Tested-by, Bisected-by, what have you...
[...]
> stuff like e.g. Tested-by or Bisected-by tags actually undermine what
> the DCE 1.1 update should have accomplished.
[...]

Last time when I read a discussion about these tags, people at least at 
this side of the pond seemed to come to the conclusion that we ask 
testers for their consent if in doubt, before adding such a tag if they 
didn't do so themselves.  (That's different from how we handle Acked-by: 
from fellow developers which we often imply from an informally given OK.)
-- 
Stefan Richter
-=====-==--- -=== ====-
http://arcgraph.de/sr/
