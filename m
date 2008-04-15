Return-Path: <linux-kernel-owner+w=401wt.eu-S1763507AbYDOE6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763507AbYDOE6U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 00:58:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753513AbYDOE6E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 00:58:04 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:44367 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753111AbYDOE6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 00:58:01 -0400
Date: Tue, 15 Apr 2008 05:57:38 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Crispin Cowan <crispin@crispincowan.com>
Cc: Matthew Wilcox <matthew@wil.cx>,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, paul.moore@hp.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, takedakn@nttdata.co.jp,
       linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [TOMOYO #7 30/30] Hooks for SAKURA and TOMOYO.
Message-ID: <20080415045738.GE9785@ZenIV.linux.org.uk>
References: <20080404122242.867070732@I-love.SAKURA.ne.jp> <20080404122408.986477936@I-love.SAKURA.ne.jp> <200804071140.59247.paul.moore@hp.com> <47FC8052.9070409@nttdata.co.jp> <20080409131151.GK11962@parisc-linux.org> <200804112312.HGE69734.LFOOHQOSFFMJtV@I-love.SAKURA.ne.jp> <20080411143013.GB11962@parisc-linux.org> <4802B63F.2010804@crispincowan.com> <20080414134858.GV11962@parisc-linux.org> <48041F46.8030004@crispincowan.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48041F46.8030004@crispincowan.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2008 at 08:21:42PM -0700, Crispin Cowan wrote:

> See above. The major classes of things that namespaces can't do are:
> 
>    * deliberate overlap

How do you think new namespaces are created[1] and how, in your opinion, do
they look right after that?

[1] no, "openvz crowd posts a patch revealing yet another offense against
Occam's Razor" is not the right answer to this question.
