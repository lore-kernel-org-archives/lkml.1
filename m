Return-Path: <linux-kernel-owner+w=401wt.eu-S1755430AbZJ1STn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755430AbZJ1STn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 14:19:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753640AbZJ1STm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 14:19:42 -0400
Received: from foo.birdnet.se ([213.88.146.6]:40327 "HELO foo.birdnet.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752875AbZJ1STm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 14:19:42 -0400
Message-ID: <20091028181946.30927.qmail@stuge.se>
Date: Wed, 28 Oct 2009 19:19:46 +0100
From: Peter Stuge <peter@stuge.se>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Dropped characters in serial connection without flow control
Mail-Followup-To: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
	Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <20091028175937.27472.qmail@stuge.se> <20091028180544.GA3523@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091028180544.GA3523@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> > There is no(!) support for flow control in the hardware.
> > 
> > Is there anything I can do
> 
> What's wrong with XON/XOFF?

That was my thought also. I asked about flow control, both hardware
and software, and got word from the firmware developer that the
device firmware can not be changed to support hardware flow control.
I didn't get a comment on XON/XOFF and have already asked again.
Meanwhile I wanted to also check here.


> And since when is adding a UART to a hardware chip expensive these
> days?

I agree. I'm trying to work toward a more advanced hardware solution.


//Peter
