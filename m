Return-Path: <linux-kernel-owner+w=401wt.eu-S1751935AbXBFQUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751935AbXBFQUd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 11:20:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752187AbXBFQUd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 11:20:33 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:52978 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751935AbXBFQUc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 11:20:32 -0500
Date: Tue, 6 Feb 2007 19:19:13 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: "Ahmed S. Darwish" <darwish.07@gmail.com>
Cc: linux-kernel@vger.kernel.org, GregKH <greg@kroah.com>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH 2.6.20] w1: Use ARRAY_SIZE macro when appropriate
Message-ID: <20070206161913.GA1080@2ka.mipt.ru>
References: <20070206160204.GA8991@Ahmed> <20070206160933.GP8991@Ahmed>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20070206160933.GP8991@Ahmed>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.7.5 (2ka.mipt.ru [0.0.0.0]); Tue, 06 Feb 2007 19:19:18 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 06, 2007 at 06:09:33PM +0200, Ahmed S. Darwish (darwish.07@gmail.com) wrote:
> Hi all,
> 
> A patch to use ARRAY_SIZE macro already defined in kernel.h
> 
> Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>

Your patch is corrent, thanks Ahmed.

Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>

Andrew, Greg will you pick it up, or should I resend it alone?

-- 
	Evgeniy Polyakov
