Return-Path: <linux-kernel-owner+w=401wt.eu-S1755030AbZINIGB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755030AbZINIGB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 04:06:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754824AbZINIGA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 04:06:00 -0400
Received: from casper.infradead.org ([85.118.1.10]:60688 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754677AbZINIF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 04:05:59 -0400
Subject: Re: [PATCH 7/8] perf: Add a perf record --timechart option
From: Peter Zijlstra <peterz@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, fweisbec@gmail.com
In-Reply-To: <20090912130645.2765de6d@infradead.org>
References: <20090912130306.5d0086ea@infradead.org>
	 <20090912130645.2765de6d@infradead.org>
Content-Type: text/plain
Date: Mon, 14 Sep 2009 10:06:00 +0200
Message-Id: <1252915560.5699.35.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-09-12 at 13:06 +0200, Arjan van de Ven wrote:
> This patch adds a "perf record --timechart" option, to make it easy
> to capture traces for use by the timechart tool.

Would it perhaps make sense to make that:

 perf timechart record

?

