Return-Path: <linux-kernel-owner+w=401wt.eu-S1756109AbYJVSDz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756109AbYJVSDz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 14:03:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752611AbYJVSDq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 14:03:46 -0400
Received: from nlpi053.sbcis.sbc.com ([207.115.36.82]:58280 "EHLO
	nlpi053.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545AbYJVSDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 14:03:46 -0400
Date: Wed, 22 Oct 2008 11:03:30 -0700 (PDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@quilx.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Cyrill Gorcunov <gorcunov@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] SLUB - define OO_ macro instead of hardcoded numbers
In-Reply-To: <48FF6800.20705@cs.helsinki.fi>
Message-ID: <Pine.LNX.4.64.0810221103170.27088@quilx.com>
References: <20081022161836.GG9639@localhost> <Pine.LNX.4.64.0810220926130.7633@quilx.com>
 <20081022163530.GH9639@localhost> <20081022165354.GI9639@localhost>
 <20081022172103.GJ9639@localhost> <Pine.LNX.4.64.0810221037320.7633@quilx.com>
 <48FF6800.20705@cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-Spam-Score: -2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Oct 2008, Pekka Enberg wrote:

> Maybe call the page->objects maximum MAX_OBJS_PER_PAGE as it's not strictly 
> related to the other OO code?

Yes. Sounds good.

