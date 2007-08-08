Return-Path: <linux-kernel-owner+w=401wt.eu-S933985AbXHHOMj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933985AbXHHOMj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 10:12:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934671AbXHHOLz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 10:11:55 -0400
Received: from adsl-70-250-156-241.dsl.austtx.swbell.net ([70.250.156.241]:46599
	"EHLO gw.microgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122AbXHHOLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 10:11:54 -0400
Subject: Re: Serial buffer memory leak
From: Paul Fulghum <paulkf@microgate.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Laurent Pinchart <laurentp@cse-semaphore.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070808144532.5e3a1998@the-village.bc.nu>
References: <200708081158.06843.laurentp@cse-semaphore.com>
	 <20070808144532.5e3a1998@the-village.bc.nu>
Content-Type: text/plain
Date: Wed, 08 Aug 2007 09:11:47 -0500
Message-Id: <1186582307.3394.3.camel@x2.microgate.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-08-08 at 14:45 +0100, Alan Cox wrote:
> > I'm not familiar enough with the tty code to decide what the proper fix should 
> > be. I'll try to write a patch if someone could point me in the right 
> > direction.
> 
> Something like this perhaps ?

That looks good, a little better than the solution
I was first considering. I'm compiling now.

This was a nasty bug for me to introduce :-(
Good work in finding this Laurent.

--
Paul Fulghum
Microgate Systems, Ltd

