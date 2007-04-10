Return-Path: <linux-kernel-owner+w=401wt.eu-S1030678AbXDJOaG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030678AbXDJOaG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 10:30:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030680AbXDJOaG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 10:30:06 -0400
Received: from wr-out-0506.google.com ([64.233.184.225]:30696 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030678AbXDJOaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 10:30:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:reply-to:mail-followup-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=Kxiav0Xxcr1lXAMkMuT2WKTas7IPPzL6mLJ+d4J4/TzGgJMs29HOSsaXei6Ws7sG5xkT2x25WYCVDQLOVOJBVmkRYvE/y8RInOiscRzqcT7reNCQ54zh5lZ/SlVZQBJmWUI06bSm8YU62WQbwrRfJJJWEHu0Ura7gfH7CYxYonc=
Date: Tue, 10 Apr 2007 22:33:13 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] Add spaces on either side of case "..." operator.
Message-ID: <20070410143313.GE3382@localhost.localdomain>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
Mail-Followup-To: "Robert P. J. Day" <rpjday@mindspring.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>
References: <Pine.LNX.4.64.0704100721050.13729@CPE00045a9c397f-CM001225dbafb6>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0704100721050.13729@CPE00045a9c397f-CM001225dbafb6>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 10, 2007 at 07:23:35AM -0400, Robert P. J. Day wrote:
>
>Following the programming advice laid down in the gcc manual, make
>sure the case "..." operator has spaces on either side.
>
>Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
>

Acked-by: WANG Cong <xiyou.wangcong@gmail.com>

