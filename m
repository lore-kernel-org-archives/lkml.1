Return-Path: <linux-kernel-owner+w=401wt.eu-S1751890AbXDOAYA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751890AbXDOAYA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 20:24:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753170AbXDOAYA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 20:24:00 -0400
Received: from electron.quantumfyre.co.uk ([87.106.55.16]:40755 "EHLO
	electron.quantumfyre.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751890AbXDOAX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 20:23:59 -0400
Date: Sun, 15 Apr 2007 01:23:56 +0100 (BST)
From: Julian Phillips <julian@quantumfyre.co.uk>
X-X-Sender: jp3@beast.quantumfyre.co.uk
To: Rene Herman <rene.herman@gmail.com>
cc: Chris Wright <chrisw@sous-sol.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       git@vger.kernel.org
Subject: Re: GIT and the current -stable
In-Reply-To: <46216001.3000503@gmail.com>
Message-ID: <Pine.LNX.4.64.0704150110490.17780@beast.quantumfyre.co.uk>
References: <46206842.80203@gmail.com> <20070414083410.GU6602@sequoia.sous-sol.org>
 <462096AA.3080003@gmail.com> <46216001.3000503@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 15 Apr 2007, Rene Herman wrote:

>
> "v2.6.20.7" seems to be the only tag from the stable branches that's present
>  in this tree?
>
> rene@7ixe4:[...]$ git tag -l | grep "v2\.6\.[[:digit:]]\{1,2\}\."
> v2.6.20.7

Obviously I don't know how Chris created his conglomerated repo, but I 
just made one of my own, and it has all the tags I would expect in it ... 
so it's not an inherent git problem (or not in 1.5.1.1 anyway).

I guess that Chris created his in such a way that the automated tag 
following code didn't trigger? (Or maybe used a really old git?)

(Mine's at http://git.q42.co.uk/w/stable.git if anyone is interested 
enough to want to look at it ...)

It only took me 4 commands to create too (ok, so three of them were bash 
for loops ... and I did do a little bit more to tidy up), I do enjoy using 
flexible tools :D.

-- 
Julian

  ---
Go slowly to the entertainments of thy friends, but quickly to their
misfortunes.
 		-- Chilo
