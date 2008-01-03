Return-Path: <linux-kernel-owner+w=401wt.eu-S1758672AbYACEhf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758672AbYACEhf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 23:37:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754809AbYACEh2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 23:37:28 -0500
Received: from po-out-1718.google.com ([72.14.252.153]:51248 "EHLO
	po-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753574AbYACEh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 23:37:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=v4FtsMuz3m2ydEAD9pXdWR47rcjsEen9Z/abEw4Y8YQ1+VBee3P8owO6w5G3VWMmWVO1X3wU4pS7I7ojPe6rYEaBqWPQZdBtyQ5ZAK/M/BzxU7N9N6yjwiUTNEgouBvjv967veqe+KqiDNkIfJfmKfuDxdQr4WbNirm8F9sxVlM=
Date: Thu, 3 Jan 2008 12:37:32 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: WANG Cong <xiyou.wangcong@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-kbuild@vger.kernel.org, Andrew Morton <akpm@osdl.org>
Subject: Re: [Patch 0/8] Remove 'TOPDIR' from Makefiles
Message-ID: <20080103043732.GA2505@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <20080101071311.GA2496@hacking> <20080102095159.GB7815@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080102095159.GB7815@uranus.ravnborg.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>Hi Wang.
>
>You a heads up. I will most likely apply
>the remaining of the patches tonight, except the UM stuff
>which I hope Jeff to take and the final removal of TOPDIR
>may wait a bit.
>I want the s390, xfs and um changes to hit -mm at least
>and we have several external modules that uses TOPDIR.
>
>And some of these external modules I care about - not
>all of them but some of them.
>
>	Sam

Thanks, Sam!

 Cong

