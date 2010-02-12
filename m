Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750918Ab0BLFVc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 00:21:32 -0500
Received: from one.firstfloor.org ([213.235.205.2]:53361 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750701Ab0BLFVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 00:21:31 -0500
Date: Fri, 12 Feb 2010 06:21:26 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Jiri Slaby <jirislaby@gmail.com>,
       linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>,
       Kay Sievers <kay.sievers@suse.de>, Neil Horman <nhorman@tuxdriver.com>
Subject: Re: oops in uevent_helper [was: mmotm 2010-01-13-12-17 uploaded]
Message-ID: <20100212052126.GA21783@one.firstfloor.org>
References: <201001132042.o0DKgaSR027272@imap1.linux-foundation.org> <4B50C2FA.4020100@gmail.com> <4B50FC78.9010107@gmail.com> <20100122155237.e93a1c55.akpm@linux-foundation.org> <4B730EE3.4080405@gmail.com> <20100211205745.GA18202@basil.fritz.box> <20100211142513.b1fd6e7a.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100211142513.b1fd6e7a.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> urgh, must I?  That trashes Neil's
> kmod-add-init-function-to-usermodehelper.patch and
> kmod-replace-call_usermodehelper_pipe-with-use-of-umh-init-function-and-resolve-limit.patch
> and probably requires repairing other stuff and sets the testing status
> back to "square one".
> 
> If you have patches queued, please make the time to support them!

Ok, understood. I'll try to look into it today. You want incrementals?

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
