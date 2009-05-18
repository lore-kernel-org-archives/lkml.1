Return-Path: <linux-kernel-owner+w=401wt.eu-S1752697AbZERS0M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697AbZERS0M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 14:26:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751790AbZERSZ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 14:25:58 -0400
Received: from plexity.net ([206.123.115.38]:45165 "EHLO plexity.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751433AbZERSZ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 14:25:58 -0400
Date: Mon, 18 May 2009 18:24:54 +0000
From: Deepak Saxena <dsaxena@plexity.net>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 8250: Don't restore NS16550 mode when console suspend
	is disabled
Message-ID: <20090518182454.GA13297@plexity.net>
Reply-To: dsaxena@plexity.net
References: <20090512210015.GA25540@plexity.net> <alpine.LFD.2.01.0905121452190.3343@localhost.localdomain> <20090513011842.22d9cd6c@lxorguk.ukuu.org.uk> <20090513002850.GA28422@plexity.net> <20090513094409.50c2409f@lxorguk.ukuu.org.uk> <alpine.LFD.2.01.0905130755090.3343@localhost.localdomain> <20090513163507.556c3832@lxorguk.ukuu.org.uk> <20090513180436.GA5592@plexity.net> <20090513194651.78e02ec2@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090513194651.78e02ec2@lxorguk.ukuu.org.uk>
Organization: Plexity, LLC
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On May 13 2009, at 19:46, Alan Cox was caught saying:
> > > So can we apply Deepak's original correct 2008 patch instead please ?
> > 
> > I've updated it with proper header and attached.
> 
> Thanks - much better approach.

Alan, is this queued up for .31?

Thanks,
~Deepak

-- 
In the end, they will not say, "those were dark times,"  they will ask
"why were their poets silent?" - Bertold Brecht

