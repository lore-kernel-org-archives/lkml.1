Return-Path: <linux-kernel-owner+w=401wt.eu-S1753010AbYKYKAl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753010AbYKYKAl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 05:00:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752519AbYKYKAd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 05:00:33 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:46059 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502AbYKYKAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 05:00:33 -0500
Subject: Re: [PATCH 00/20] [MTD] Namespace cleanup for MTD drivers
From: David Woodhouse <dwmw2@infradead.org>
To: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
In-Reply-To: <1227574511-23879-1-git-send-email-dmitri.vorobiev@movial.fi>
References: <1227574511-23879-1-git-send-email-dmitri.vorobiev@movial.fi>
Content-Type: text/plain
Date: Tue, 25 Nov 2008 10:00:29 +0000
Message-Id: <1227607229.2665.4.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 (2.24.2-1.fc10) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-11-25 at 02:54 +0200, Dmitri Vorobiev wrote:
> 
> It has come to my attention that many MTD drivers needlessly define
> their module entry points as global symbols. The patch series that
> follows fixes all such places that I was able to identify. Please
> consider.

Many years ago, that was necessary. Now, it's not. Thank you for
cleaning it up.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

