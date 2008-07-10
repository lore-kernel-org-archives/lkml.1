Return-Path: <linux-kernel-owner+w=401wt.eu-S932301AbYGJSxL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932301AbYGJSxL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 14:53:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759161AbYGJSwj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 14:52:39 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:56134 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758915AbYGJSwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 14:52:38 -0400
Date: Thu, 10 Jul 2008 14:52:21 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [uml-devel] UML kernel failed to start betvee 2.6.8-rc8 and
	current git sources
Message-ID: <20080710185221.GI18429@c2.user-mode-linux.org>
References: <200807101619.54052.toralf.foerster@gmx.de> <20080710165811.GA18429@c2.user-mode-linux.org> <200807101934.33636.toralf.foerster@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200807101934.33636.toralf.foerster@gmx.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2008 at 07:34:29PM +0200, Toralf Förster wrote:
> At Thursday 10 July 2008 18:58:11 Jeff Dike wrote :
> > On Thu, Jul 10, 2008 at 04:19:51PM +0200, Toralf Förster wrote:
> > > from v2.6.26-rc8 to v2.6.26-rc9-56-g6329d30 sth. affected UML, b/c my user mode linux kernel produces this :
> > 
> > That UML runs fine here.  Did you also upgrade the host kernel between
> > rc8 and now?
> > 
> Yes, but that's not the reason. The UML crashes both under host kernel
> 2.6.24-gentoo-r8 and 2.6.25-gentoo-r6. The last (available) working UML kernel
> is linux-v2.6.26-rc8-227 (tested under host kernel 2.6.25-gentoo-r6).

Can you send me your crashing UML binary?

Also, can you bisect this and see where something broke?

      	      	     	  Jeff

-- 
Work email - jdike at linux dot intel dot com
