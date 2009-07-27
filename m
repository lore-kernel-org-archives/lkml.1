Return-Path: <linux-kernel-owner+w=401wt.eu-S1753165AbZG0QS6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753165AbZG0QS6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 12:18:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753101AbZG0QS5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 12:18:57 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:57261 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753086AbZG0QS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 12:18:56 -0400
Date: Mon, 27 Jul 2009 09:18:24 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Greg KH <gregkh@suse.de>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Lucian Adrian Grijincu <lgrijincu@ixiacom.com>
Subject: Re: [PATCH] documentation: make it clear that sysfs is optional
Message-Id: <20090727091824.38d55ea1.randy.dunlap@oracle.com>
In-Reply-To: <20090727161031.GA15328@suse.de>
References: <20090727090642.0e495919.randy.dunlap@oracle.com>
	<20090727161031.GA15328@suse.de>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt007.oracle.com [141.146.116.16]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010208.4A6DD369.0193:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Jul 2009 09:10:33 -0700 Greg KH wrote:

> On Mon, Jul 27, 2009 at 09:06:42AM -0700, Randy Dunlap wrote:
> > From:	Lucian Adrian Grijincu <lgrijincu@ixiacom.com>
> > Subject: [PATCH] documentation: make it clear that sysfs is optional
> > 
> > The original text suggested that sysfs is mandatory and always
> > compiled in the kernel.
> 
> But it should be :)

Well, you have the option of making it non-optional.


> Seriously, who turns sysfs off these days, does anyone?  If so, why?

Why is it configurable then?


---
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
