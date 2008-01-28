Return-Path: <linux-kernel-owner+w=401wt.eu-S1752550AbYA1FWJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752550AbYA1FWJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 00:22:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750780AbYA1FV5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 00:21:57 -0500
Received: from qb-out-0506.google.com ([72.14.204.227]:62208 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727AbYA1FV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 00:21:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=cuGiq7+e03k6TAhT//bQBpRdPiJs5TyQGtClcJbWpbcoEmCN4NhvdPkT2+B4fy1KMdpjjQppADQVlMZO6l00GQVyu7uJBtIGUfY8STPxlFZlbhm6jrKHivpFlCVn08X1VkCCtW/q93AcROGgMlv8CJ7U6SadAeVG9Y5YxHsEgFg=
Date: Mon, 28 Jan 2008 13:19:24 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: WANG Cong <xiyou.wangcong@gmail.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Patch] drivers/base/core.c: fix a compile error
Message-ID: <20080128051924.GA3099@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <479A4867.9040302@goop.org> <20080125221731.GB15172@suse.de> <20080125150002.09cdacb8.rdunlap@xenotime.net> <20080125231129.GD25074@suse.de> <479A6F9D.8040402@goop.org> <20080126091445.GA20935@hacking> <20080127194053.GA17136@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080127194053.GA17136@suse.de>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>
>No, that will fix the build error, but die when linking :(
>
>I'll work on a real fix for this now...
>

Sorry.

I just compiled it since the building process was stopped
by another error.


