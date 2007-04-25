Return-Path: <linux-kernel-owner+w=401wt.eu-S1031069AbXDYPjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031069AbXDYPjR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 11:39:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031093AbXDYPjR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 11:39:17 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:44034 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1031069AbXDYPjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 11:39:17 -0400
Date: Wed, 25 Apr 2007 08:39:16 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: John Stoffel <john@stoffel.org>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: Re: Serial console problem in 2.6.21-rc7-mm1 and earlier
In-Reply-To: <17967.29851.680497.648681@smtp.charter.net>
Message-ID: <Pine.LNX.4.64.0704250838360.24504@schroedinger.engr.sgi.com>
References: <20070424130601.4ab89d54.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0704241320540.13005@schroedinger.engr.sgi.com>
 <20070424132740.e4bdf391.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0704241332090.13005@schroedinger.engr.sgi.com>
 <20070424134325.f71460af.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0704241351400.13382@schroedinger.engr.sgi.com>
 <20070424141826.952d2d32.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0704241421140.13904@schroedinger.engr.sgi.com>
 <17967.29851.680497.648681@smtp.charter.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Apr 2007, John Stoffel wrote:

> Christoph> I use a serial console on my x86_84 box. For a while now I
> Christoph> can see all output but I cannot type any
> Christoph> characters. /dev/console broke?
> 
> I've sorta seen this problem too, but with gdm.  If I have my kernel
> line setup like this:
> 
> 	... console=tty0 console=ttyS0,9600n8
> 
> I have to stop and restart gdm (or switch to the XDMCP chooser and
> back) to get keyoard access.  Wierd. 
> 
> Christoph> Simple WAR is to ssh into the box and I was usually too
> Christoph> focused on other issues to do something about it.
> 
> Are you trying to access an X login prompter, or just a plain Virtual
> Console tty?

No X on the machine. And this is a serial console that works fine with 
2.6.21-rcX.

