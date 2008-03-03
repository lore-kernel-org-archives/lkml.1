Return-Path: <linux-kernel-owner+w=401wt.eu-S1756860AbYCCScm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756860AbYCCScm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 13:32:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752712AbYCCScd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 13:32:33 -0500
Received: from vena.lwn.net ([206.168.112.25]:43203 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752195AbYCCScc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 13:32:32 -0500
To: Neal Becker <ndbecker2@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Books on writing linux device drivers 
From: corbet@lwn.net (Jonathan Corbet)
In-reply-to: Your message of "Mon, 03 Mar 2008 13:00:26 EST."
             <fqhebq$os3$1@ger.gmane.org> 
Date: Mon, 03 Mar 2008 11:32:30 -0700
Message-ID: <5384.1204569150@vena.lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I am about to start on writing a linux device driver.  What books are
> recommended?  There are some books that are a few years old now, that deal
> with 2.4 kernel.  What would be useful for a relatively recent kernel?

LDD3 covers the 2.6.10 kernel:

	http://lwn.net/Kernel/LDD3/

That's still on the old side at this point, of course, but it's a far
cry from 2.4.  

jon
