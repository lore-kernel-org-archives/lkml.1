Return-Path: <linux-kernel-owner+w=401wt.eu-S1756217AbYGaKCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756217AbYGaKCV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 06:02:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753023AbYGaKCI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 06:02:08 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38719
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753258AbYGaKCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 06:02:05 -0400
Date: Thu, 31 Jul 2008 03:02:05 -0700 (PDT)
Message-Id: <20080731.030205.153067850.davem@davemloft.net>
To: dwmw2@infradead.org
Cc: torvalds@linux-foundation.org, thomas.petazzoni@free-electrons.com,
       linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       michael@free-electrons.com
Subject: Re: [patch 0/4] [resend] Add configuration options to disable
 features not needed on embedded devices
From: David Miller <davem@davemloft.net>
In-Reply-To: <1217498355.3454.103.camel@pmac.infradead.org>
References: <1217497912.3454.95.camel@pmac.infradead.org>
	<20080731.025547.35826309.davem@davemloft.net>
	<1217498355.3454.103.camel@pmac.infradead.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Woodhouse <dwmw2@infradead.org>
Date: Thu, 31 Jul 2008 10:59:15 +0100

> I have drivers which don't even _have_ ethtool support, and they seem to
> work fine. But leaving aside the debate on that point, your statement
> also seemed to be covering the other patches, such as the IGMP one and
> others which haven't been seen (or perhaps even imagined) yet.

I explained why I didn't want to apply the IGMP one too.

Andrew didn't like my objections, but that doesn't mean I
need to defend my position further.

Show me a size reduction patch for networking that actually
makes real sense and I'll apply it.
