Return-Path: <linux-kernel-owner+w=401wt.eu-S1753524AbZLALj5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753524AbZLALj5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 06:39:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753167AbZLALj4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 06:39:56 -0500
Received: from mail1.radix.net ([207.192.128.31]:49394 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752947AbZLALjz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 06:39:55 -0500
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel
 IR  system?
From: Andy Walls <awalls@radix.net>
To: Christoph Bartelmus <lirc@bartelmus.de>
Cc: jonsmirl@gmail.com, dmitry.torokhov@gmail.com, j@jannau.net,
       jarod@redhat.com, jarod@wilsonet.com, khc@pm.waw.pl,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-media@vger.kernel.org, lirc-list@lists.sourceforge.net,
       mchehab@redhat.com, superm1@ubuntu.com
In-Reply-To: <BE3edeNXqgB@lirc>
References: <BE3edeNXqgB@lirc>
Content-Type: text/plain
Date: Tue, 01 Dec 2009 06:38:00 -0500
Message-Id: <1259667480.3100.10.camel@palomino.walls.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-12-01 at 08:45 +0100, Christoph Bartelmus wrote:
> Hi Jon,
> 
> on 30 Nov 09 at 16:35, Jon Smirl wrote:


> Currently I would tend to an approach like this:
> - raw interface to userspace using LIRC
> - fixed set of in-kernel decoders that can handle bundled remotes
> 
> That would allow zero configuration for simple use cases and full  
> flexibility for more advanced use cases.
> 
> Christoph

I'd also prefer that approach.

That probably comes as no surprise, but I may not be able to keep
following/kibitzing in this thread. Christoph's statement sums up my
preference.

Regards,
Andy

