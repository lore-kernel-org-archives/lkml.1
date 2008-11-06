Return-Path: <linux-kernel-owner+w=401wt.eu-S1752800AbYKFO46@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800AbYKFO46 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 09:56:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751268AbYKFO4v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 09:56:51 -0500
Received: from nlpi053.sbcis.sbc.com ([207.115.36.82]:47475 "EHLO
	nlpi053.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143AbYKFO4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 09:56:50 -0500
Date: Thu, 6 Nov 2008 08:56:19 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@quilx.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mel@csn.ul.ie>,
       linux-mm <linux-mm@kvack.org>
Subject: Re: [RFC][PATCH] mm: the page of MIGRATE_RESERVE don't insert into
 pcp
In-Reply-To: <20081106091431.0D2A.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Message-ID: <Pine.LNX.4.64.0811060856020.3595@quilx.com>
References: <20081106091431.0D2A.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -2.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And the fastpath gets even more complex. Sigh.

