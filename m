Return-Path: <linux-kernel-owner+w=401wt.eu-S1753068AbXBJJvl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753068AbXBJJvl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 04:51:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753069AbXBJJvl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 04:51:41 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60905 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753066AbXBJJvl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 04:51:41 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: current git breaks resume
Date: Sat, 10 Feb 2007 10:49:47 +0100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <20070209190307.GC6152@kernel.dk>
In-Reply-To: <20070209190307.GC6152@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702101049.47889.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Friday, 9 February 2007 20:03, Jens Axboe wrote:
> Hi,
> 
> Unfortunately I'm a little short on time as I'll be travelling tomorrow,
> but of course preparing a new kernel for the laptop is something you
> want to do right before leaving. So I discovered that the current (well
> as of yesterday, HEAD is 5986a2ec35836a878350c54af4bd91b1de6abc59)
> doesn't resume on my x60. 2.6.20 works fine, so something broke since
> then.

I think the patch from

http://marc.theaimsgroup.com/?l=linux-acpi&m=117103448629685&w=2

is likely to help.

Greetings,
Rafael


-- 
If you don't have the time to read,
you don't have the time or the tools to write.
		- Stephen King
