Return-Path: <linux-kernel-owner+w=401wt.eu-S1754316Ab0AEOiH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754316Ab0AEOiH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 09:38:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753795Ab0AEOiF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 09:38:05 -0500
Received: from kroah.org ([198.145.64.141]:51360 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753660Ab0AEOiE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 09:38:04 -0500
Date: Tue, 5 Jan 2010 06:32:54 -0800
From: Greg KH <greg@kroah.com>
To: Stefani Seibold <stefani@seibold.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Johan Hovold <jhovold@gmail.com>, Pete Zaitcev <zaitcev@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-usb@vger.kernel.org
Subject: Re: [tip:urgent] fix USB serial fix kfifo_len locking
Message-ID: <20100105143254.GA11488@kroah.com>
References: <20100104174352.GA26606@localhost>
 <1262632804.4814.17.camel@wall-e>
 <20100105004344.082bb69f@redhat.com>
 <20100105110418.GA10442@localhost>
 <1262689759.21020.2.camel@wall-e>
 <20100105111401.GB10442@localhost>
 <1262690734.22009.3.camel@wall-e>
 <20100105113525.GA19371@localhost>
 <1262692881.23577.15.camel@wall-e>
 <1262698231.4532.4.camel@wall-e>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1262698231.4532.4.camel@wall-e>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 05, 2010 at 02:30:31PM +0100, Stefani Seibold wrote:
> This patch fix a possible race bug in drivers/usb/serial/generic with
> the new kfifo API.
> 
> Please apply it to the 2.6.33-rc* tree.
> 
> Signed-off-by: Stefani Seibold <stefani@seibold.net>

I will queue it up, thanks,

greg k-h
