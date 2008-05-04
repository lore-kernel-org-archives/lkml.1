Return-Path: <linux-kernel-owner+w=401wt.eu-S1756544AbYEDMa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756544AbYEDMa0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 08:30:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755350AbYEDMaN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 08:30:13 -0400
Received: from relay1.sgi.com ([192.48.171.29]:40163 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755244AbYEDMaM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 08:30:12 -0400
Date: Sun, 4 May 2008 07:30:08 -0500
From: Robin Holt <holt@sgi.com>
To: Alistair John Strachan <alistair@devzero.co.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: Linux 2.6.26-rc1
Message-ID: <20080504123008.GE19717@sgi.com>
References: <alpine.LFD.1.10.0805031205330.2971@woody.linux-foundation.org> <200805032247.38738.alistair@devzero.co.uk> <200805032253.22765.alistair@devzero.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200805032253.22765.alistair@devzero.co.uk>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 03, 2008 at 10:53:22PM +0100, Alistair John Strachan wrote:
> On Saturday 03 May 2008 22:47:38 Alistair John Strachan wrote:
> > On Saturday 03 May 2008 20:38:20 Linus Torvalds wrote:
> > > So go out and test it.
> [snip]
> > Why is this option acting like CONFIG_EMBEDDED and not like basically every
> > other subsystem where I can turn ON support for hardware, but by default
> > it's OFF? (Obviously in my hasty oldconfig run I just went with the
> > default.)
> 
> Amazingly, even if I say Y to this option and disable all tuners, it still 
> tries (and fails) to compile this file. What is pulling in this tuner-core 
> dependency?

What if you change CONFIG_MEDIA_TUNER to a 'n'

Robin
