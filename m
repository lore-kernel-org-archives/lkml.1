Return-Path: <linux-kernel-owner+w=401wt.eu-S1757099AbYGZSgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757099AbYGZSgT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 14:36:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752051AbYGZSgH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 14:36:07 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33060 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751886AbYGZSgG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 14:36:06 -0400
Date: Sat, 26 Jul 2008 12:33:48 -0600
From: Pete Zaitcev <zaitcev@redhat.com>
To: Alan <alan@clueserver.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: Problem mounting Motorola USB device
Message-Id: <20080726123348.782a2776.zaitcev@redhat.com>
In-Reply-To: <1217096347.5892.1.camel@rotwang>
References: <52610.198.182.194.170.1216229551.squirrel@clueserver.org>
	<20080725235122.0e097f1f.akpm@linux-foundation.org>
	<20080726112249.1ade4980.zaitcev@redhat.com>
	<1217096347.5892.1.camel@rotwang>
Organization: Red Hat, Inc.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.13.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Jul 2008 11:19:07 -0700, Alan <alan@clueserver.org> wrote:

> > Want a practical suggestion? Try to stick the card into a common
> > many-in-one reader, a SanDisk SDDR-somenumber would usually work.
> > Save the data.
> 
> This actually causes a kernel oops.  I will post debug info soon.

Probably unrelated, but must be fixed.

> I will get more info now that OSCON is over.

Thanks.

One question: can you switch to self-built kernels instead of supplied
by Fedora, just for this bug? It would be easier for me to look at
(I'm speaking in the USB hacker capacity here rather than as one
of Chuck's underlings).

-- Pete
