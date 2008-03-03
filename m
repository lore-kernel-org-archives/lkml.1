Return-Path: <linux-kernel-owner+w=401wt.eu-S1761640AbYCCExL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761640AbYCCExL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 23:53:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753180AbYCCEw7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 23:52:59 -0500
Received: from gv-out-0910.google.com ([216.239.58.187]:2068 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752684AbYCCEw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 23:52:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=ioFLn210dJjbaJCKyw9e+AZCuuRiw49xxX4MfVtbQ+vKHA1nI58e1r3m2tMFOJYyEQPvrRvLTZ9I9kx/4peV/yNcNd4qbkpMov7JsMYZVvApXUisi8PSQi6EYEW9hWB0ogkdlWymzd0OXeeHU7Qg5Wqq2cfze2ohPBsgMXpDd84=
Message-ID: <877aabc40803022052p44aa8d26nc2333b7c08126aea@mail.gmail.com>
Date: Mon, 3 Mar 2008 10:22:55 +0530
From: "Amit Shah" <amitshah@gmx.net>
To: "Rusty Russell" <rusty@rustcorp.com.au>
Subject: Re: [PATCH] VIRTIO NET: Enable netpoll interface for netconsole logging
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org
In-Reply-To: <200803031508.18063.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <877aabc40802290254k2ecc559at2a3bc9740cd82ebc@mail.gmail.com>
	 <200803031508.18063.rusty@rustcorp.com.au>
X-Google-Sender-Auth: deea27d3a743b71d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 3, 2008 at 9:38 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> On Friday 29 February 2008 21:54:50 Amit Shah wrote:
>  > Add a new poll_controller handler that the netpoll interface needs.
>  >
>  > This enables netconsole logging from a kvm guest over the virtio
>  > net interface.
>  >
>  > Signed-off-by: Amit Shah <amitshah@gmx.net>
>
>  Wow, does this actually work?

Yes, it does :-)

>  If so, I'll apply it no problems...
>  Rusty.

Thanks.
Amit.

-- 
Amit Shah
http://www.amitshah.net/
