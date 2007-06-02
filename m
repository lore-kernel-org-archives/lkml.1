Return-Path: <linux-kernel-owner+w=401wt.eu-S1764059AbXFBX3e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764059AbXFBX3e (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 19:29:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762291AbXFBX32
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 19:29:28 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:34868 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762288AbXFBX31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 19:29:27 -0400
Date: Sat, 2 Jun 2007 16:29:27 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Sam Ravnborg <sam@ravnborg.org>
cc: Roman Zippel <zippel@linux-m68k.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Dave Jones <davej@redhat.com>
Subject: Re: Conditionals for development tests and output
In-Reply-To: <20070602190236.GA10768@uranus.ravnborg.org>
Message-ID: <Pine.LNX.4.64.0706021627360.15441@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0706012113200.11472@schroedinger.engr.sgi.com>
 <20070602190236.GA10768@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2 Jun 2007, Sam Ravnborg wrote:

> The below patch suffers from the problem that changing the
> value of DEVELKERNEL in the Makefile are not automatically
> reflected in autoconf.h.

Well you are restating what is in the description. See below.

> We need to get this fixed before merging this I think.

I thought you would maybe able to help?

> > Editing DEVELKERNEL requires a 
> > 
> > 	make clean
> > 
> > to correctly rebuild the kernel with the proper settings. This is similar 
> > to editing the version number. Sam: Is there any way to avoid the make 
> > clean?
   ^^^^^^^^^^^^

