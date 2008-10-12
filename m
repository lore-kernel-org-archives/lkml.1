Return-Path: <linux-kernel-owner+w=401wt.eu-S1755284AbYJLX2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284AbYJLX2S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 19:28:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754086AbYJLX2J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 19:28:09 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45761 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754032AbYJLX2I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 19:28:08 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <alpine.LFD.2.00.0810121245260.3402@nehalem.linux-foundation.org>
References: <alpine.LFD.2.00.0810121245260.3402@nehalem.linux-foundation.org> <20081010235755.12643.43818.stgit@warthog.procyon.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dhowells@redhat.com, akpm@linux-foundation.org, linux-am33-list@redhat.com,
       linux-kernel@vger.kernel.org, Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH] MN10300: MEI are renaming themselves to Panasonic
Date: Mon, 13 Oct 2008 00:27:50 +0100
Message-ID: <21119.1223854070@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> wrote:

> Hmm. Somehow I'd expect this to also move to late in the file to keep 
> things in alphabetical order. No?

Good point.  Do you want me to redo my patch on top of Randy's?

David
