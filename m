Return-Path: <linux-kernel-owner+w=401wt.eu-S1755355AbZDZRbt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355AbZDZRbt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 13:31:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754186AbZDZRbk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 13:31:40 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:49077 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753610AbZDZRbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 13:31:39 -0400
Date: Sun, 26 Apr 2009 13:28:16 -0400 (EDT)
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
cc: Paul Mundt <lethal@linux-sh.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <andi@firstfloor.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, Jeff Arnold <jbarnold@MIT.EDU>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jon Masters <jonathan@jonmasters.org>,
       Masami Hiramatsu <mhiramat@redhat.com>, "Theodore Ts'o" <tytso@MIT.EDU>,
       Nikanth Karthikesan <knikanth@suse.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Am?rico Wang <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH] kbuild: fix comment in modpost.c
In-Reply-To: <20090426092056.GA28058@uranus.ravnborg.org>
Message-ID: <alpine.DEB.1.10.0904261326550.10199@vinegar-pot.mit.edu>
References: <alpine.DEB.1.10.0904221826180.24694@vinegar-pot.mit.edu> <1240519774-20307-1-git-send-email-tabbott@mit.edu> <20090424172358.GA21946@uranus.ravnborg.org> <alpine.DEB.1.10.0904251304120.7631@vinegar-pot.mit.edu> <20090426024221.GA7286@linux-sh.org>
 <20090426092056.GA28058@uranus.ravnborg.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 26 Apr 2009, Sam Ravnborg wrote:

> - *   Whitelist all refereces from .text.head to .init.data
> - *   Whitelist all refereces from .text.head to .init.text
> + *   Whitelist all refereces from .head.text to any init section

While you're fixing that you might as well fix the spelling of 
"references".

	-Tim Abbott
