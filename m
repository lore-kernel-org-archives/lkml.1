Return-Path: <linux-kernel-owner+w=401wt.eu-S1752821AbYDWKvA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821AbYDWKvA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 06:51:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752390AbYDWKus
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 06:50:48 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37974
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755064AbYDWKur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 06:50:47 -0400
Date: Wed, 23 Apr 2008 03:50:49 -0700 (PDT)
Message-Id: <20080423.035049.136615011.davem@davemloft.net>
To: bunk@kernel.org
Cc: davem@sunset.davemloft.net, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] unexport uts_sem
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080423095215.GG28933@cs181133002.pp.htv.fi>
References: <20080423095215.GG28933@cs181133002.pp.htv.fi>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Bunk <bunk@kernel.org>
Date: Wed, 23 Apr 2008 12:52:15 +0300

> With the removal of the Solaris binary emulation the export of 
> uts_sem became unused.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Acked-by: David S. Miller <davem@davemloft.net>
