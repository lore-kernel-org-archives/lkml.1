Return-Path: <linux-kernel-owner+w=401wt.eu-S1753209AbYLUEoX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209AbYLUEoX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 23:44:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751185AbYLUEoP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 23:44:15 -0500
Received: from kroah.org ([198.145.64.141]:55047 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751144AbYLUEoP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 23:44:15 -0500
Date: Sat, 20 Dec 2008 19:25:21 -0800
From: Greg KH <greg@kroah.com>
To: Peter <peter_mj2002@yahoo.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: sysfs programming
Message-ID: <20081221032521.GA2529@kroah.com>
References: <188539.35426.qm@web35306.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <188539.35426.qm@web35306.mail.mud.yahoo.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 20, 2008 at 12:13:23AM -0800, Peter wrote:
> Hi , 
> I am writing a project for my university and i am planning on using
> sysfs for my kernel module to communicate with user space , ive read
> some articles and i know how sysfs works, its just i dont know how the
> code should be written .  Could you please send me a sample code about
> how to create an attribute file at /sys/module/(some kernel module)/
> please ?

What is wrong with the examples in the kernel tree itself?  Are they not
sufficient in some way?

thanks,

greg k-h
