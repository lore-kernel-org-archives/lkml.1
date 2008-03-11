Return-Path: <linux-kernel-owner+w=401wt.eu-S1752629AbYCKQTN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752629AbYCKQTN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 12:19:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751390AbYCKQS6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 12:18:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37484 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751138AbYCKQS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 12:18:58 -0400
Date: Tue, 11 Mar 2008 09:18:05 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Pavel Machek <pavel@ucw.cz>
cc: Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [GIT PATCH] USB suspend persistance for 2.6.25-rc5 git
In-Reply-To: <20080311102746.GA31701@atrey.karlin.mff.cuni.cz>
Message-ID: <alpine.LFD.1.00.0803110916560.5896@woody.linux-foundation.org>
References: <20080311004239.GD17890@suse.de> <20080311102746.GA31701@atrey.karlin.mff.cuni.cz>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 11 Mar 2008, Pavel Machek wrote:
> 
> I'd really prefer this to go to 2.6.26-rc1. This screams like "needs a
> lot of testing" patch.

I think it's pretty sane and safe, but I declined to pull it anyway. I 
want to set a good example, rather than pull because I think something is 
a good feature.

		Linus
