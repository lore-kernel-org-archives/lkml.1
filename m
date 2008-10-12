Return-Path: <linux-kernel-owner+w=401wt.eu-S1754763AbYJLTq0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754763AbYJLTq0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 15:46:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751387AbYJLTqS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 15:46:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54122 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751096AbYJLTqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 15:46:17 -0400
Date: Sun, 12 Oct 2008 12:46:01 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
cc: akpm@linux-foundation.org, linux-am33-list@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MN10300: MEI are renaming themselves to Panasonic
In-Reply-To: <20081010235755.12643.43818.stgit@warthog.procyon.org.uk>
Message-ID: <alpine.LFD.2.00.0810121245260.3402@nehalem.linux-foundation.org>
References: <20081010235755.12643.43818.stgit@warthog.procyon.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 11 Oct 2008, David Howells wrote:
>
> MEI are renaming themselves to Panasonic, so update the MAINTAINERS record for
> the MN10300 arch.

Hmm. Somehow I'd expect this to also move to late in the file to keep 
things in alphabetical order. No?

> -MEI MN10300/AM33 PORT
> +PANASONIC MN10300/AM33 PORT

Hmm?

		Linus
