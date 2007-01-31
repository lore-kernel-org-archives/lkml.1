Return-Path: <linux-kernel-owner+w=401wt.eu-S932077AbXAaBzN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932077AbXAaBzN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 20:55:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932080AbXAaBzM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 20:55:12 -0500
Received: from paris.bmts.com ([216.183.128.227]:38124 "EHLO paris.bmts.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932077AbXAaBzL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 20:55:11 -0500
Date: Tue, 30 Jan 2007 20:48:39 -0500
From: Mike Houston <mikeserv@bmts.com>
To: Adrian Bunk <bunk@stusta.de>
Cc: Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: How many people are using 2.6.16?
Message-Id: <20070130204839.4124e9f3.mikeserv@bmts.com>
In-Reply-To: <20070130235215.GN3754@stusta.de>
References: <45BE5948.6060403@redhat.com>
	<20070129160448.65fc63f3.mikeserv@bmts.com>
	<20070130235215.GN3754@stusta.de>
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-brucetelecom.com-MailScanner-Information: Please contact Bruce Telecom 519.368.2000 for more information
X-brucetelecom.com-MailScanner: Found to be clean
X-brucetelecom.com-MailScanner-From: mikeserv@bmts.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Jan 2007 00:52:15 +0100
Adrian Bunk <bunk@stusta.de> wrote:

> On Mon, Jan 29, 2007 at 04:04:48PM -0500, Mike Houston wrote:

> > I've been using Adrian's 2.6.16 kernel releases on two internet
> > servers that I look after remotely. One of them is RHEL 4 the
> > other is Fedora Core 2 (Ensim Webppliance). I'm especially wary
> > of breaking RHEL 4, and the 2.6.16.xx kernels work perfectly
> > except for the hald not starting (but that doesn't matter on that
> > server).
> >...
> 
> I haven't heard of this before, and in a quick test hald from
> HAL 0.5.8.1 starts fine here.
> 
> Are there any error messages?
>

I think I recall hearing about hald breaking in rhel4 with modern
kernels here on this list, some time before I built a custom kernel
for that rig (Athlon 64 3200+ on Asus A8V w' VIA K8T800Pro chipset
running 32 bit RHEL 4 ES). I was expecting it to happen. I think at
the time, the current kernel was 2.6.15.2 or thereabouts.

However, I haven't upgraded any software that's in the distro packages
beyond what up2date provides, so:

$ rpm -qa | grep hal
hal-0.4.2-4.EL4

So sorry about that, I didn't mean to take up any of your time. I
only mentioned it incidentally and wasn't expecting it to be
addressed. (I was more happily stating that nothing of significance
to me is broken in the distro). If that was something I needed, I
would have looked into upgrading it.

Mike Houston
