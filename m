Return-Path: <linux-kernel-owner+w=401wt.eu-S1759149AbZKFDdg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759149AbZKFDdg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 22:33:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758755AbZKFDdg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 22:33:36 -0500
Received: from netrider.rowland.org ([192.131.102.5]:33251 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757852AbZKFDdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 22:33:35 -0500
Date: Thu, 5 Nov 2009 22:33:40 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: fangxiaozhi <huananhu@huawei.com>, Greg KH <greg@kroah.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: More Huawei modem woes
In-Reply-To: <1257475252.13611.255.camel@pasglop>
Message-ID: <Pine.LNX.4.44L0.0911052233001.12193-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Nov 2009, Benjamin Herrenschmidt wrote:

> On Fri, 2009-11-06 at 11:55 +1100, Benjamin Herrenschmidt wrote:
> 
> > Of course it's always possible that a whole lot of users have been
> > testing the wrong kernel and thus don't have the fix :-) But that might
> > also show a different problem with those modems usb storage
> > implementation.
> 
> And indeed, the user -does- have the wrong kernel...

And indeed, the log shows exactly the same problem as your modem had.  
So presumably the same code change will fix it.

Alan Stern

