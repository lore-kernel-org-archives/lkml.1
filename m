Return-Path: <linux-kernel-owner+w=401wt.eu-S934239AbZIOCCh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934239AbZIOCCh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 22:02:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934230AbZIOCCf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 22:02:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49623 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934222AbZIOCCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 22:02:31 -0400
Date: Mon, 14 Sep 2009 19:02:17 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: James Morris <jmorris@namei.org>
cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
       selinux@tycho.nsa.gov, Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: [PATCH] SELinux: inline selinux_is_enabled in
 !CONFIG_SECURITY_SELINUX
In-Reply-To: <alpine.LRH.2.00.0909151134250.13708@tundra.namei.org>
Message-ID: <alpine.LFD.2.01.0909141901160.4950@localhost.localdomain>
References: <20090915005948.12692.40854.stgit@paris.rdu.redhat.com> <alpine.LRH.2.00.0909151134250.13708@tundra.namei.org>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 15 Sep 2009, James Morris wrote:
> 
> Linus, I'll assume you'll want to apply this directly.

What I want is to just get pull requests that were well tested in the 
first place. When I see an error in a pull request, my reaction is to just 
reset awat from it, and not wanting to have anything what-so-ever to do 
with the git tree I pulled from.

Give me a few days to get over the disgust.

		Linus
