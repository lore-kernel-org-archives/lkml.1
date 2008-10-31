Return-Path: <linux-kernel-owner+w=401wt.eu-S1753234AbYJaUN0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234AbYJaUN0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 16:13:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752277AbYJaUNS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 16:13:18 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48630 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271AbYJaUNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 16:13:17 -0400
Date: Fri, 31 Oct 2008 20:13:15 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Re: alpha: undefined reference to `save_stack_trace'
Message-ID: <20081031201315.GW28946@ZenIV.linux.org.uk>
References: <20081031165751.GA13558@x200.localdomain> <20081031182411.GR28946@ZenIV.linux.org.uk> <20081031184822.GS28946@ZenIV.linux.org.uk> <20081031185526.GT28946@ZenIV.linux.org.uk> <20081031190608.GU28946@ZenIV.linux.org.uk> <20081031195040.GV28946@ZenIV.linux.org.uk> <alpine.DEB.1.10.0810311604040.28774@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0810311604040.28774@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2008 at 04:05:01PM -0400, Steven Rostedt wrote:
> 
> Ingo,
> 
> I guess this is needed to make alph (and perhasp others compile).

... and shitloads more than alpha.  Itanic, parisc, all embedded ones,
m68k, uml, sparc32...
