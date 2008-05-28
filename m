Return-Path: <linux-kernel-owner+w=401wt.eu-S1755325AbYE1W2n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325AbYE1W2n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 18:28:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753768AbYE1W2e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 18:28:34 -0400
Received: from ra.tuxdriver.com ([70.61.120.52]:4875 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753650AbYE1W2d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 18:28:33 -0400
Date: Wed, 28 May 2008 17:48:12 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Alejandro Riveira =?iso-8859-1?Q?Fern=E1ndez?= 
	<ariveira@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-wireless@vger.kernel.org
Subject: Re: Linux 2.6.26-rc4
Message-ID: <20080528214812.GB3133@tuxdriver.com>
References: <alpine.LFD.1.10.0805261127030.2958@woody.linux-foundation.org> <20080527124315.131b1343@Varda> <alpine.LFD.1.10.0805281307150.2958@woody.linux-foundation.org> <1212005877.21624.47.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1212005877.21624.47.camel@johannes.berg>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2008 at 10:17:57PM +0200, Johannes Berg wrote:

> > I suspect the oops is also why the bootup breaks, so it's likely all the 
> > same issue. Please save the dmesg into a file, reboot into a working 
> > setup, and send that. Along with hw information (it's likely related to 
> > your network device driver, since I've not seen an uproar of these kinds 
> > of problems from everybody else..).
> 
> Actually, please apply the patch "﻿rt2x00: Use atomic interface
> iteration in irq context" before trying anything more, that'll fix it.
> I'm not sure where Linville is hiding ;)
> 
> (http://article.gmane.org/gmane.linux.kernel.wireless.general/15268)

Zzzzzzz....huh, what?? :-)

I just sent a pull request to Dave M. with that patch in it.
Last weekend was a long one in the USA, so I apologize for the delay...

John
-- 
John W. Linville
linville@tuxdriver.com
