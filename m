Return-Path: <linux-kernel-owner+w=401wt.eu-S1753638Ab0ARKpd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753638Ab0ARKpd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 05:45:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752843Ab0ARKpc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 05:45:32 -0500
Received: from smtp-out.google.com ([216.239.44.51]:8380 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751Ab0ARKpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 05:45:31 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=uFsW5jU0vwKuobgKbk+EYTqxZC9TDQVeFTO/CqBX4HFITvASHyyX3HEPt9JI4QpXt
	MT570O8XbLIRYnG+bjjUQ==
Date: Mon, 18 Jan 2010 02:45:28 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Michal Marek <mmarek@suse.cz>
cc: Ingo Molnar <mingo@elte.hu>, Stephen Rothwell <sfr@canb.auug.org.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] kbuild: improve version string logic
In-Reply-To: <4B542C99.9000801@suse.cz>
Message-ID: <alpine.DEB.2.00.1001180243300.20677@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1001041330230.26148@chino.kir.corp.google.com> <4B4345AF.9040600@suse.cz> <alpine.DEB.2.00.1001131300360.26527@chino.kir.corp.google.com> <20100116063754.GC20342@elte.hu> <20100116183445.29fc5d50.sfr@canb.auug.org.au>
 <20100116092658.GA23999@elte.hu> <4B542C99.9000801@suse.cz>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jan 2010, Michal Marek wrote:

> >>> Given that Sam doesnt maintain the kbuild tree anymore, would this patch be a 
> >>> good fit for -mm perhaps?
> >>
> >> There is a new kbuild tree maintainer: Michal Marek <mmarek@suse.cz>
> > 
> > Good. Michal, what do you think about David's patch?
> 
> The patch is OK, I already commented on a previous version and this
> addresses the two minor issues I had. I was just too busy last week to
> apply it. I will do so ASAP now.
> 

Michal, where are you hosting your git tree?  Are you going to be taking 
over kbuild-next on git.kernel.org?
