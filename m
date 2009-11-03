Return-Path: <linux-kernel-owner+w=401wt.eu-S1755754AbZKCGwj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755754AbZKCGwj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 01:52:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751796AbZKCGwi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 01:52:38 -0500
Received: from mail-px0-f179.google.com ([209.85.216.179]:35950 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264AbZKCGwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 01:52:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=qj6DmGtxlyUnt7RJgxDw7BoD2UHeKWca/GrTrc2zS3OzAur/tWc1TWqpYN6+94eKt5
         75Lr+uuq6sdPfbDSKls/CbgBZ9PoSVPxLBtMHIqy7/1XRXxkFcN4Q4pIe+eQ1x7TIE4Y
         90AkFl4l/0FwIJi6RmTEj78O2fN13t8TUOmoo=
Date: Mon, 2 Nov 2009 22:52:38 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, johannes@sipsolutions.net,
       linville@tuxdriver.com, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org
Subject: Re: Please consider reverting
	7d930bc33653d5592dc386a76a38f39c2e962344
Message-ID: <20091103065238.GE3212@core.coreip.homeip.net>
References: <20091103053156.GA3212@core.coreip.homeip.net> <20091102.224957.32364226.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091102.224957.32364226.davem@davemloft.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 02, 2009 at 10:49:57PM -0800, David Miller wrote:
> From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Date: Mon, 2 Nov 2009 21:31:56 -0800
> 
> > Hi Linus,
> > 
> > It looks like
> > 
> > commit 7d930bc33653d5592dc386a76a38f39c2e962344
> > Author: Johannes Berg <johannes@sipsolutions.net>
> > Date:   Tue Oct 20 15:08:53 2009 +0900
>  ...
> > is causing oops on resume:
> 
> There is a fix for this in my tree and I'll push it to Linus
> tonight.

Ah, even better ;) Thanks David.

-- 
Dmitry
