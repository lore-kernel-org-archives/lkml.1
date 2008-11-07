Return-Path: <linux-kernel-owner+w=401wt.eu-S1754748AbYKGSoY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748AbYKGSoY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 13:44:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753827AbYKGSoB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 13:44:01 -0500
Received: from nlpi053.sbcis.sbc.com ([207.115.36.82]:45555 "EHLO
	nlpi053.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753481AbYKGSoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 13:44:00 -0500
Date: Fri, 7 Nov 2008 12:43:06 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@quilx.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, travis@sgi.com,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Vegard Nossum <vegard.nossum@gmail.com>
Subject: Re: [patch 7/7] cpu alloc: page allocator conversion
In-Reply-To: <20081107093137.F84D.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Message-ID: <Pine.LNX.4.64.0811071242560.5387@quilx.com>
References: <20081106115113.0D38.KOSAKI.MOTOHIRO@jp.fujitsu.com>
 <Pine.LNX.4.64.0811060904030.3595@quilx.com> <20081107093137.F84D.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -2.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Nov 2008, KOSAKI Motohiro wrote:

> However, if cpu-unplug happend, any pages in pcp should flush to buddy (I think).

Right. They are not?

