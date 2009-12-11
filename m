Return-Path: <linux-kernel-owner+w=401wt.eu-S1762741AbZLKXTl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762741AbZLKXTl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 18:19:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762711AbZLKXTf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 18:19:35 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35660 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762529AbZLKXTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 18:19:35 -0500
Date: Fri, 11 Dec 2009 15:19:24 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Dave Airlie <airlied@linux.ie>
cc: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org
Subject: Re: [git pull] drm nouveau pony for Xmas.
In-Reply-To: <alpine.DEB.2.00.0912111148250.4178@skynet.skynet.ie>
Message-ID: <alpine.LFD.2.00.0912111516550.3526@localhost.localdomain>
References: <alpine.DEB.2.00.0912111148250.4178@skynet.skynet.ie>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 11 Dec 2009, Dave Airlie wrote:
> 
> Please pull the 'drm-nouveau-pony' branch from

PONIES! Yay! I lurve ponies!

And it works for me too. Needed to get the firmware from the fedora 
project, and make sure that it loads as a module rather than built in (so 
that it can find the firmware!), but other than those two gotchas (that 
are "obvious", but I needed to fail a couple of boots to hammer the point 
home) it all seems to work.

Thank you. The squeaky wheel _does_ get greased.

		Linus
