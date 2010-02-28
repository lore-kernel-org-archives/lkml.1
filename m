Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032048Ab0B1UpM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 15:45:12 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:37367 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032025Ab0B1UpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 15:45:10 -0500
Date: Sun, 28 Feb 2010 20:45:06 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Andrea Gelmini <andrea.gelmini@gelma.net>
Cc: Jeff Dike <jdike@addtoit.com>, linux-kernel@vger.kernel.org,
       user-mode-linux-user@lists.sourceforge.net,
       user-mode-linux-devel@lists.sourceforge.net, gregkh@suse.de
Subject: Re: [uml-devel] [PATCH 66/66]
 arch/um/sys-x86_64/shared/sysdep/skas_ptrace.h: Checkpatch cleanup
Message-ID: <20100228204506.GQ30031@ZenIV.linux.org.uk>
References: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
 <1267289508-31031-67-git-send-email-andrea.gelmini@gelma.net>
 <20100227221310.GA5455@localhost.localdomain>
 <9cdbb57f1002280606j6d6ca697k21f42cff87d685de@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9cdbb57f1002280606j6d6ca697k21f42cff87d685de@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 28, 2010 at 03:06:21PM +0100, Andrea Gelmini wrote:
> 2010/2/27 Jeff Dike <jdike@addtoit.com>:
> Hi Jeff,
>    and thanks for your reply.
> 
> > Don't you have anything better to do with your time?
> 
> It's a dirty job, but somebody has to do it...
> Enlighted by Greg's talk at FOSDEM?? I sent him some patches (nothing
> more than boring things for a real programmer, but a good solitaire
> alternative for a rookie like me).
> 
> These patches are just a try to see if there are other subtree
> maintainers interested in stuff like this.

Note to gregkh: the next time you give a talk like that, consider including
"spamming l-k with sixty-odd solitaire sessions^W^Wwhitespace-removal patches
can lead to considerable annoyance"...
