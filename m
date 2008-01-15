Return-Path: <linux-kernel-owner+w=401wt.eu-S1752057AbYAOIql@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752057AbYAOIql (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 03:46:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752248AbYAOIqV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 03:46:21 -0500
Received: from viefep18-int.chello.at ([213.46.255.22]:58438 "EHLO
	viefep11-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751283AbYAOIqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 03:46:18 -0500
Subject: Re: [patch] Converting writeback linked lists to a tree based data
	structure
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Michael Rubin <mrubin@google.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, wfg@mail.ustc.edu.cn
In-Reply-To: <20080115080921.70E3810653@localhost>
References: <20080115080921.70E3810653@localhost>
Content-Type: text/plain
Date: Tue, 15 Jan 2008 09:46:14 +0100
Message-Id: <1200386774.15103.20.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.4 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-01-15 at 00:09 -0800, Michael Rubin wrote:
> From: Michael Rubin <mrubin@google.com>
> 
> For those of you who have waited so long. This is the third submission
> of the first attempt at this patch. It is a trilogy.

Just a quick question, how does this interact/depend-uppon etc.. with
Fengguangs patches I still have in my mailbox? (Those from Dec 28th)





