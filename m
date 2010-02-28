Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932254Ab0B1S2N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 13:28:13 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:37012 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754422Ab0B1S2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 13:28:11 -0500
Date: Sun, 28 Feb 2010 10:28:39 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Andrea Gelmini <andrea.gelmini@gelma.net>
Cc: linux-kernel@vger.kernel.org, user-mode-linux-user@lists.sourceforge.net,
       user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [uml-devel] [PATCH 66/66]
	arch/um/sys-x86_64/shared/sysdep/skas_ptrace.h: Checkpatch cleanup
Message-ID: <20100228152839.GA3063@localhost.localdomain>
References: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net> <1267289508-31031-67-git-send-email-andrea.gelmini@gelma.net> <20100227221310.GA5455@localhost.localdomain> <9cdbb57f1002280606j6d6ca697k21f42cff87d685de@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9cdbb57f1002280606j6d6ca697k21f42cff87d685de@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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

To be a bit more serious, the UML tree was once a seething mass of
checkpatch violations.  I cleaned up a lot of it while making other
changes in the area.  This sort of thing I think is reasonably
worthwhile, but dumping in a whole lot of checkpatch changes doesn't
help anything and it just pollutes the change history.

				Jeff
