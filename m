Return-Path: <linux-kernel-owner+w=401wt.eu-S1753659AbZIKO66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753659AbZIKO66 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 10:58:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752347AbZIKO66
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 10:58:58 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:46782 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557AbZIKO65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 10:58:57 -0400
Date: Fri, 11 Sep 2009 07:58:47 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: arve@android.com, swetland@google.com,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: newer version of HTC Dream support
Message-Id: <20090911075847.2fb7210a.randy.dunlap@oracle.com>
In-Reply-To: <20090911071155.GA1386@ucw.cz>
References: <20090824092204.GB25591@elf.ucw.cz>
	<20090901131832.GA1835@ucw.cz>
	<20090904090303.024e981a.randy.dunlap@oracle.com>
	<20090911071155.GA1386@ucw.cz>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt013.oracle.com [141.146.116.22]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4AAA65A9.01B4:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Sep 2009 09:16:16 +0200 Pavel Machek wrote:

> Hi!
> 
> > > > With 2.6.31 being closer... is there a git tree or set of patches to
> > > > make it boot on HTC Dream?
> > > > 
> > > > Quite a lot of hw should be supported in linux-next, and it would be
> > > > nice to get arch-specific code working with linux-next and eventually
> > > > merged...
> > > 
> > > Any news here? If you need some more kernel hackers I guess I'm
> > > looking for a job :-).
> > 
> > well, mmotm and linux-next dream builds fail like this:
> 
> Ok, is the goal here to get it to compile, or get it to boot?

Can you do b. (boot) without a. (compile)?


> I have recent tree that compiles, somewhere, but getting it to boot is
> 'slightly more interesting'.

Sure, booting is more interesting.  Especially if one has the device.

---
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
