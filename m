Return-Path: <linux-kernel-owner+w=401wt.eu-S1755601AbZLNAik@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755601AbZLNAik (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 19:38:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755028AbZLNAij
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 19:38:39 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:34656 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754184AbZLNAii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 19:38:38 -0500
Date: Sun, 13 Dec 2009 17:38:36 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: re.emese@gmail.com
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       viro@zeniv.linux.org.uk, akpm@linux-foundation.org
Subject: Re: [PATCH 0/1] Constify struct address_space_operations for
	2.6.32-git-053fe57ac v2
Message-ID: <20091214003836.GD7812@parisc-linux.org>
References: <cover.1260662994.git.re.emese@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1260662994.git.re.emese@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 14, 2009 at 12:59:08AM +0100, re.emese@gmail.com wrote:
> From: Emese Revfy <re.emese@gmail.com>
> 
> Hello everyone!
> 
> The following patch series attempts to constify several structures
> that hold function pointers. This is only the initial batch, there
> are about over 150 candidate structures, some of which can be
> constified as well, I plan to submit them in the future.

What a complete waste of time.  Until you respond to Al's:

  This is ugly and has all marks of cargo-cult patches.  NAKed at least
  until you give exceptionally good reasons for doing that.

you should stop sending patches.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
