Return-Path: <linux-kernel-owner+w=401wt.eu-S935480AbYEBSth@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935480AbYEBSth (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 14:49:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762285AbYEBSt3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 14:49:29 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:37992 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756253AbYEBSt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 14:49:29 -0400
Date: Fri, 2 May 2008 12:49:22 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org, Dave Jones <davej@redhat.com>
Subject: Re: [PATCH] Extend list debugging to cover hlists
Message-ID: <20080502184922.GM14976@parisc-linux.org>
References: <20080502182745.GL14976@parisc-linux.org> <20080501133209.2c04dad0@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080501133209.2c04dad0@infradead.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 01, 2008 at 01:32:09PM -0700, Arjan van de Ven wrote:
> I like the concept of the patch; however...
> BUG() is a tad on the rude side... how about WARN_ON(1) ?

I'm just copying the conventions of the code above.  If those should be
WARN_ON(1) then that should be a followup patch.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
