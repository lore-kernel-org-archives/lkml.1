Return-Path: <linux-kernel-owner+w=401wt.eu-S1755649AbYGTAgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755649AbYGTAgR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 20:36:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754528AbYGTAgG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 20:36:06 -0400
Received: from ax54.genwebserver.com ([72.18.156.50]:53424 "EHLO
	ax54.genwebserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754468AbYGTAgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 20:36:05 -0400
Message-ID: <487D0564.7070606@assumpcao.org>
Date: Tue, 15 Jul 2008 17:15:32 -0300
From: Tiago Assumpcao <tiago@assumpcao.org>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: pageexec@freemail.hu, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [stable] Linux 2.6.25.10
References: <20080703185727.GA12617@suse.de>, <486D4541.25808.C600354@pageexec.freemail.hu>, <20080714120418.GA5334@kroah.com> <487C242B.19490.17F690F7@pageexec.freemail.hu> <alpine.LFD.1.10.0807141924020.3017@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0807141924020.3017@woody.linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - ax54.genwebserver.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - assumpcao.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> That means that I want to fix things asap. But that also means that there is never a 
> time when you can "let people know", except when it's not an issue any 
> more, at which point there is no _point_ in letting people know any more.
> 

The only plausible solution people have found to this problem is
"letting the world know", so everyone involved in the different stages
of IT maintenance can do their part and properly spread the solution
throughout the assets.

Unless you have a better idea, the full-disclosure policy must remain or
we're going back into 1992AD -- except the threats are thereof 2008.

> So I personally consider security bugs to be just "normal bugs". I don't 
> cover them up, but I also don't have any reason what-so-ever to think it's 
> a good idea to track them and announce them as something special. 
> 
> So there is no "policy". Nor is it likely to change. 
> 
> 			Linus

Either someone classify and inform it as it is, a *security problem*, or 
the issue is likely to pass unnoticed by the majority or to not receive 
the necessary attention by the involved parts.

Right. You don't want your developers to be responsible for classifying 
bugs towards security. Fine. Even though my intuition and personal 
experience tell that the question must be approached by those deeply 
involved in the development life-cycle, which, on their side, are 
responsible for finding, classifying, advising and fixing the security 
issues. This seems appropriate. Further, this appears to be what the big 
software houses nowadays do: from early design and development stages, 
have people to [security] review their applications before deployment, 
up to giving high attention and adequate support to any reported 
security problem, afterwards release. Maybe this is all silly and the 
world is swimming in the wrong direction.

Opinions apart, what really matters: we have an ultimate declaration 
about Linus' tree -- we may forget the pre-official (?) announcement 
[Documentation/SecurityBugs] and know that someone else must, 
eventually, classify and inform the world about security bugs existent 
in their software.
 From our consumer side, every time an issue of this nature is found, 
let's pray for some intermediate, gray, angel to send us an "warning" 
message.


Not more I can do but to make sure that all my peers are informed of 
such a grave reality.

Sincerely,
Tiago

