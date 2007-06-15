Return-Path: <linux-kernel-owner+w=401wt.eu-S1754027AbXFOO3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027AbXFOO3S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 10:29:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751809AbXFOO3J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 10:29:09 -0400
Received: from bipbip.grupopie.com ([195.23.16.24]:57702 "EHLO
	bipbip.grupopie.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751289AbXFOO3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 10:29:08 -0400
Message-ID: <4672A231.9000800@grupopie.com>
Date: Fri, 15 Jun 2007 15:29:05 +0100
From: Paulo Marques <pmarques@grupopie.com>
Organization: Grupo PIE
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: Bernd Paysan <bernd.paysan@gmx.de>
CC: Al Viro <viro@ftp.linux.org.uk>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Krzysztof Halasa <khc@pm.waw.pl>, linux-kernel@vger.kernel.org
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <466A3EC6.6030706@netone.net.tr> <200706151014.45383.bernd.paysan@gmx.de> <46727CCF.9030905@grupopie.com> <200706151403.57178.bernd.paysan@gmx.de>
In-Reply-To: <200706151403.57178.bernd.paysan@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bernd Paysan wrote:
> On Friday 15 June 2007 13:49, Paulo Marques wrote:
>> I've contributed some code for the kernel (unlike yourself, AFAICT), and
>> believe me, I did so under GPL v2. The COPYING file is pretty much self
>> explanatory, so I didn't need to add any explicit license statement to
>> my code.
> 
> It's not, it's a personal comment from a misunderstanding of the GPL text. 
> It's as valid as the "closed source kernel modules are legal" comment that 
> was there some years ago.

These are not changes to the license text. These are just clarifications 
to help people understand the license. They don't change what the 
license already said.

>> People seem to forget that the kernel license in COPYING *never had* the
>> "v2 or later" clause. Never. Period.
> 
> It's there in section 9.

The section 9 is meant to explain how you select one version of the 
license in a program without having to copy the entire license text to 
it, i.e., in simple programs you can just put the small text, suggested 
by FSF at the bottom of the gpl, and have the version number there, and 
that should be enough to reference the entire text.

But COPYING *is* the entire text and starts with: "
		    GNU GENERAL PUBLIC LICENSE
		       Version 2, June 1991"

so there is no confusion about the version.

>>[...]
>> And people who write kernel code are perfectly aware that the kernel
>> license is GPL v2 only, and always has been (except for the initial
>> linus license).
> 
> Wrong.

Why do you say "Wrong"? Have you contributed some code to the kernel 
thinking that the kernel was "v2 or later", only to find out later that 
it wasn't?

In case you haven't followed previous discussions, here's a pointer:

http://lkml.org/lkml/2006/9/22/176

The major kernel developers (and probably most of the total number of 
developers) are perfectly aware of the kernel license and chose GPL v2.

I'm getting pretty tired of listening to people that just _know_ what I 
should do with _my_ code. And people who treat kernel developers as 
morons who can't read a license.

We definitely need more Al Viro style comments on this thread ;)

-- 
Paulo Marques - www.grupopie.com

"The Mexicans have the Chupacabra. We have Al Viro. If you hear him 
roar, just _pray_ he's about to dissect somebody elses code than yours.. 
There is no point in running."

Linus Torvalds
