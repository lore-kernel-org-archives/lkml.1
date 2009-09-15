Return-Path: <linux-kernel-owner+w=401wt.eu-S1754678AbZIOPHO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678AbZIOPHO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 11:07:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754529AbZIOPHL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 11:07:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39416 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754518AbZIOPHK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 11:07:10 -0400
Date: Tue, 15 Sep 2009 08:04:55 -0700
From: Greg KH <gregkh@suse.de>
To: Denys Fedoryschenko <denys@visp.net.lb>
Cc: linux-kernel@vger.kernel.org
Subject: Re: unable to handle kernel NULL pointer / tty / 2.6.31-vanilla/
 still persists
Message-ID: <20090915150455.GA22282@suse.de>
References: <200909151032.53683.denys@visp.net.lb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200909151032.53683.denys@visp.net.lb>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 15, 2009 at 10:32:53AM +0300, Denys Fedoryschenko wrote:
> Kernel 2.6.31-rc7
> x86 , 32-bit
> gcc 4.4.1
> 
> Happened on heavy network load, looks like as previous one, seems problem 
> still persists.
> It is hyperthreading Xeon, as i heard on such CPU's SMP bugs most easy to 
> trigger. But for me triggered after few days of operation.
> 
> Here is oops:

Ugh.

What are you doing at the time of this happening?  What kind of load is
on the system?

thanks,

greg k-h
