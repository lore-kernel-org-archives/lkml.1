Return-Path: <linux-kernel-owner+w=401wt.eu-S1032667AbXHMUOu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032667AbXHMUOu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 16:14:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S942974AbXHMUN0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 16:13:26 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3617 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967227AbXHMUNX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 16:13:23 -0400
Subject: Re: [PATCH] [2/2many] - FInd the maintainer(s) for a patch
	-	MAINTAINERS
From: Joe Perches <joe@perches.com>
To: Richard Knutsson <ricknu-0@student.ltu.se>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
In-Reply-To: <46C0B8EA.9080405@student.ltu.se>
References: <1186985416.10249.13.camel@localhost>
	 <46C0B8EA.9080405@student.ltu.se>
Content-Type: text/plain
Date: Mon, 13 Aug 2007 13:12:40 -0700
Message-Id: <1187035960.10249.288.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2-2.1mdv2007.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-08-13 at 22:02 +0200, Richard Knutsson wrote:
> Just to be clear, which one is picked with a patch for drivers/net/foo? 
> Both or the most common one?
> 
> SUBSYSTEM1
> P: Person 1
> F: */net/
> 
> SUBSYSTEM2
> P: Person 2
> F: drivers/net/

Both.  Find a match, add, look for more.

I'm a perl "groper in the dark" myself.

