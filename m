Return-Path: <linux-kernel-owner+w=401wt.eu-S965553AbXCGQoW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965553AbXCGQoW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 11:44:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965554AbXCGQoW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 11:44:22 -0500
Received: from mx1.redhat.com ([66.187.233.31]:60833 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965553AbXCGQoV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 11:44:21 -0500
Message-ID: <45EEEBC9.1010002@redhat.com>
Date: Wed, 07 Mar 2007 11:43:53 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Johan Henriksson <jhn98032@gmail.com>
CC: linux-kernel@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: Radeon xpress 200m and radeonfb kinda work
References: <45ECB2D0.3080205@telia.com>
In-Reply-To: <45ECB2D0.3080205@telia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Johan Henriksson wrote:
> Hi!
> 
> I have gotten the radeon xpress 200m (the version without dedicated vmem)
> to work with radeonfb.
> The attached patch (against linux-2.6.20.1) works for me.
> Since I don't have any docs for the card I am unsure if the patch is
> 100% correct.
> Can someone else with a 200m try it out?
> (I have tested it by enabling  fbcon and radeonfb in the kernel  and
> added "video=radeonfb" to lilo. This gave me a nice 1280x800 console :) )
> 

Works for me as a module on Compaq V2000 notebook.
160x48 is a bit small, but looks very clear and crisp.

Is there anything else needed to get this merged?


