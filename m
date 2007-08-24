Return-Path: <linux-kernel-owner+w=401wt.eu-S1762330AbXHXTbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762330AbXHXTbS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 15:31:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751655AbXHXTbH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 15:31:07 -0400
Received: from nz-out-0506.google.com ([64.233.162.227]:24777 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771AbXHXTbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 15:31:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qU4z5uXGzWDHW4xlPQpgjDmBjnXLRczfgtFSW/drRCgoHMvwuzS/N4+InoY1VY1kDyAtbKV4sGtvYVJJw5GPBcYpvZqfd3tjy4cPai3Odg942UsPgo07IGneRlxAWc0Of/V5nVBR9f1Pb2ZgVXYxwRxhHOBjJQWr800megwkQi4=
Message-ID: <82e4877d0708241231j76474326ufdd19ec5448537b9@mail.gmail.com>
Date: Fri, 24 Aug 2007 15:31:03 -0400
From: "Parag Warudkar" <parag.warudkar@gmail.com>
To: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
Subject: Re: [4/4] 2.6.23-rc3: known regressions v3
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-usb-devel@lists.sourceforge.net, "Greg KH" <gregkh@suse.de>,
       "Alan Stern" <stern@rowland.harvard.edu>,
       "Oliver Neukum" <oliver@neukum.org>, "Tino Keitel" <tino.keitel@gmx.de>,
       "Zachary Amsden" <zach@vmware.com>, linux-alpha@vger.kernel.org,
       "Richard Henderson" <rth@twiddle.net>,
       "Ivan Kokshaysky" <ink@jurassic.park.msu.ru>,
       "Oliver Falk" <oliver@linux-kernel.at>
In-Reply-To: <46CF17A0.2060503@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46CF0DEF.5040107@googlemail.com> <46CF17A0.2060503@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/24/07, Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:
> Hi all,
>
> Here is a list of some known regressions in 2.6.23-rc3.
>

> Virtualization
>
> Subject         : CONFIG_VMI broken
> References      : http://lkml.org/lkml/2007/8/14/203
> Last known good : ?
> Submitter       : Parag Warudkar <parag.warudkar@gmail.com>
> Caused-By       : ?
> Handled-By      : Zachary Amsden <zach@vmware.com>
> Status          : problem is being debugged

Zach seemed to think that this is already fixed - I am not in a
position to test it immediately so if we know what fixed this - can be
closed. I'll report back once I get a chance to test latest git.

Thanks
Parag
