Return-Path: <linux-kernel-owner+w=401wt.eu-S932510AbXA2Vve@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932510AbXA2Vve (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 16:51:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932472AbXA2Vve
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 16:51:34 -0500
Received: from nicole.bmts.com ([216.183.128.225]:53574 "EHLO nicole.bmts.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932510AbXA2Vvd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 16:51:33 -0500
X-Greylist: delayed 2406 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Jan 2007 16:51:33 EST
Date: Mon, 29 Jan 2007 16:04:48 -0500
From: Mike Houston <mikeserv@bmts.com>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@stusta.de>
Subject: Re: How many people are using 2.6.16?
Message-Id: <20070129160448.65fc63f3.mikeserv@bmts.com>
In-Reply-To: <45BE5948.6060403@redhat.com>
References: <45BE5948.6060403@redhat.com>
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-brucetelecom.com-MailScanner-Information: Please contact Bruce Telecom 519.368.2000 for more information
X-brucetelecom.com-MailScanner: Found to be clean
X-brucetelecom.com-MailScanner-From: mikeserv@bmts.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Jan 2007 15:30:00 -0500
Chuck Ebbert <cebbert@redhat.com> wrote:

> Is there any way to estimate the size of the user base for 2.6.16?
> 
> e.g. how many downloads does it get?

I've often wondered that myself, as I'm concerned for it to continue
to be maintained. I'm very appreciative of what Adrian is doing with
it. (Thanks!)

I've been using Adrian's 2.6.16 kernel releases on two internet
servers that I look after remotely. One of them is RHEL 4 the other
is Fedora Core 2 (Ensim Webppliance). I'm especially wary of breaking
RHEL 4, and the 2.6.16.xx kernels work perfectly except for the
hald not starting (but that doesn't matter on that server). The stock
RHEL 4 kernels exhibit some awful VM behaviour, with crippling iowait
on that system (mainly php/mysql workload)

Mike Houston
