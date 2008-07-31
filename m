Return-Path: <linux-kernel-owner+w=401wt.eu-S1755926AbYGaJ7e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755926AbYGaJ7e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 05:59:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752979AbYGaJ7X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 05:59:23 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51828 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752459AbYGaJ7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 05:59:22 -0400
Subject: Re: [patch 0/4] [resend] Add configuration options to disable
	features not needed on embedded devices
From: David Woodhouse <dwmw2@infradead.org>
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, thomas.petazzoni@free-electrons.com,
       linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       michael@free-electrons.com
In-Reply-To: <20080731.025547.35826309.davem@davemloft.net>
References: <20080731092703.661994657@free-electrons.com>
	 <20080731.024027.162488608.davem@davemloft.net>
	 <1217497912.3454.95.camel@pmac.infradead.org>
	 <20080731.025547.35826309.davem@davemloft.net>
Content-Type: text/plain
Date: Thu, 31 Jul 2008 10:59:15 +0100
Message-Id: <1217498355.3454.103.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-07-31 at 02:55 -0700, David Miller wrote:
> From: David Woodhouse <dwmw2@infradead.org>
> Date: Thu, 31 Jul 2008 10:51:52 +0100
> 
> > But there are a lot of people who really don't need these features
> > and really want the option of leaving them out.
> 
> I'll say it one last time.
> 
> If you have ipv4 enabled, you need ETHTOOL.

I have drivers which don't even _have_ ethtool support, and they seem to
work fine. But leaving aside the debate on that point, your statement
also seemed to be covering the other patches, such as the IGMP one and
others which haven't been seen (or perhaps even imagined) yet.

-- 
dwmw2

