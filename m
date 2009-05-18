Return-Path: <linux-kernel-owner+w=401wt.eu-S1754332AbZERTGO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754332AbZERTGO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 15:06:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752782AbZERTF7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 15:05:59 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48176 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751450AbZERTF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 15:05:58 -0400
Date: Mon, 18 May 2009 20:07:02 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: dsaxena@plexity.net
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 8250: Don't restore NS16550 mode when console suspend
 is disabled
Message-ID: <20090518200702.328f8664@lxorguk.ukuu.org.uk>
In-Reply-To: <20090518182454.GA13297@plexity.net>
References: <20090512210015.GA25540@plexity.net>
	<alpine.LFD.2.01.0905121452190.3343@localhost.localdomain>
	<20090513011842.22d9cd6c@lxorguk.ukuu.org.uk>
	<20090513002850.GA28422@plexity.net>
	<20090513094409.50c2409f@lxorguk.ukuu.org.uk>
	<alpine.LFD.2.01.0905130755090.3343@localhost.localdomain>
	<20090513163507.556c3832@lxorguk.ukuu.org.uk>
	<20090513180436.GA5592@plexity.net>
	<20090513194651.78e02ec2@lxorguk.ukuu.org.uk>
	<20090518182454.GA13297@plexity.net>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 May 2009 18:24:54 +0000
Deepak Saxena <dsaxena@plexity.net> wrote:

> On May 13 2009, at 19:46, Alan Cox was caught saying:
> > > > So can we apply Deepak's original correct 2008 patch instead please ?
> > > 
> > > I've updated it with proper header and attached.
> > 
> > Thanks - much better approach.
> 
> Alan, is this queued up for .31?

I thought Linus was dealing with it directly ? If not I'll queue it.

Alan
