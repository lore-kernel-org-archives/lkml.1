Return-Path: <linux-kernel-owner+w=401wt.eu-S1161131AbXCVV4b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161131AbXCVV4b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 17:56:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161133AbXCVV4b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 17:56:31 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45921 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161131AbXCVV4b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 17:56:31 -0400
Message-ID: <4602FB7D.4070908@redhat.com>
Date: Thu, 22 Mar 2007 17:56:13 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: David Brownell <david-b@pacbell.net>
CC: linux-usb-devel@lists.sourceforge.net, Tino Keitel <tino.keitel@gmx.de>,
       Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org
Subject: Re: [linux-usb-devel] possible USB regression with 2.6.21-rc4: iPod
 doesn't work
References: <20070322085451.GB10598@dose.home.local> <Pine.LNX.4.44L0.0703221539440.4669-100000@iolanthe.rowland.org> <20070322195448.GA17521@dose.home.local> <200703221429.12029.david-b@pacbell.net>
In-Reply-To: <200703221429.12029.david-b@pacbell.net>
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Brownell wrote:
> On Thursday 22 March 2007 12:54 pm, Tino Keitel wrote:
>> On Thu, Mar 22, 2007 at 15:40:40 -0400, Alan Stern wrote:
>>> 	  _Something_ is generating those overcurrent 
>>> warnings, and it sure looks like a hardware malfunction.
>> But it works with 2.6.20.
> 
> So can you bisect to find what caused the problem?
> 
> We've been afflicted with such strange overcurrent messages
> off and on for some time.  Some hardware triggers them, while
> most doesn't, and the USB developers don't have any of the
> hardware that triggers it (that almost goes without saying).
> 

Generation 1 iPod Shuffle is notorious for high current draw.
You should be able to get the 512MB model really really cheap
by now.

