Return-Path: <linux-kernel-owner+w=401wt.eu-S1756700AbXKGFac@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756700AbXKGFac (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 00:30:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750818AbXKGFaY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 00:30:24 -0500
Received: from pip9.gyao.ne.jp ([61.122.117.247]:46522 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750698AbXKGFaX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 00:30:23 -0500
Date: Wed, 7 Nov 2007 14:30:09 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Yuichi Nakamura <ynakam@hitachisoft.jp>
Cc: linux-kernel@vger.kernel.org, sgrubb@redhat.com,
       linuxsh-dev@lists.sourceforge.net
Subject: Re: [patch] audit support for SH
Message-ID: <20071107053009.GA25290@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Yuichi Nakamura <ynakam@hitachisoft.jp>,
	linux-kernel@vger.kernel.org, sgrubb@redhat.com,
	linuxsh-dev@lists.sf.net
References: <20071107135743.C1BD.YNAKAM@hitachisoft.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071107135743.C1BD.YNAKAM@hitachisoft.jp>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 07, 2007 at 02:04:46PM +0900, Yuichi Nakamura wrote:
> I found syscall audit does not work on SH(SuperH).
> I made patch to support syscall audit for SH.
> 
> Signed-off-by: Yuichi Nakamura<ynakam@hitachisoft.jp>

Looks fine, but it's too late for 2.6.24. So this will go in to the 2.6.25
queue when I open up the 2.6.25 development tree. Thanks.
