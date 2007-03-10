Return-Path: <linux-kernel-owner+w=401wt.eu-S1752219AbXCJHvm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752219AbXCJHvm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 02:51:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752223AbXCJHvl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 02:51:41 -0500
Received: from raven.upol.cz ([158.194.120.4]:36903 "EHLO raven.upol.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752217AbXCJHvl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 02:51:41 -0500
Date: Sat, 10 Mar 2007 09:01:26 +0100
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>, Al Viro <viro@ftp.linux.org.uk>,
       akpm@linux-foundation.org, benh@kernel.crashing.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, johannes@sipsolutions.net
Subject: Re: ALIGN
Message-ID: <20070310080126.GA22960@flower.upol.cz>
References: <Pine.LNX.4.64.0703061913080.5963@woody.linux-foundation.org> <20070306173929.2708.37191.stgit@warthog.cambridge.redhat.com> <8543.1173267786@redhat.com> <E1HOybN-00031m-6M@flower> <Pine.LNX.4.64.0703070836220.5963@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703070836220.5963@woody.linux-foundation.org>
Organization: Palacky University in Olomouc, experimental physics department.
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2007 at 08:38:27AM -0800, Linus Torvalds wrote:
> 
> 
> On Wed, 7 Mar 2007, Oleg Verych wrote:
> >
> > Probably it can be used to get rid of gccisms and "type fluff" due to
> > bitwise arithmetics in ALIGN?
> 
> Hell no.
> 
> The typeof is there to make sure we have the right type, and it's simple.

Right. Now i see.

Thanks!
____
