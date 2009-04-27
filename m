Return-Path: <linux-kernel-owner+w=401wt.eu-S1758958AbZD0PPV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758958AbZD0PPV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 11:15:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932259AbZD0PKg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 11:10:36 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:35727 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932253AbZD0PKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 11:10:34 -0400
Date: Mon, 27 Apr 2009 17:12:41 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, john.williams@petalogix.com,
       monstr@monstr.eu, linux-api@vger.kernel.org, linux-arch@vger.kernel.org,
       liqin.chen@sunplusct.com,
       Remis Lima Baima <remis.developer@googlemail.com>
Subject: Re: [RFC 00/17] asm-generic ABI files for microblaze
Message-ID: <20090427151241.GA10558@uranus.ravnborg.org>
References: <200904271640.44445.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904271640.44445.arnd@arndb.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 27, 2009 at 04:40:43PM +0200, Arnd Bergmann wrote:
> This is my attempt to do a generic system call ABI for
> all new architectures, including a port for microblaze,
> which has recently been merged into 2.6.30. The next
> architecture that is about to get merged will be score,
> so it would be good if they can move to the same ABI.
> 
> Please review the files and (in case of microblaze
> and score maintainers) test them on your architecture.

The submission is seriously broken.
- subject is missing
- reply-to-all is broken

Can you resend with this fixed, then it makes review easier.

	Sam
