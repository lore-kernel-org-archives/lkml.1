Return-Path: <linux-kernel-owner+w=401wt.eu-S1757967AbZAEPBn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757967AbZAEPBn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 10:01:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756902AbZAEPAZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 10:00:25 -0500
Received: from sh.osrg.net ([192.16.179.4]:41500 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756881AbZAEPAX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 10:00:23 -0500
Date: Tue, 6 Jan 2009 00:00:15 +0900
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp
Subject: Re: [PATCH 0/13] x86: unifying ways to handle multiple sets of dma
 mapping ops
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1231166848-20149-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1231166848-20149-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090106000016W.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  5 Jan 2009 23:47:20 +0900
FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> This patchset is the second part of the unification of ways to handle
> multiple sets of dma mapping API. The whole work consists of three
> patchset. This is for X86 and can be applied independently (against
> tip/master).

Oops, I messed up the subject, should have been:

[PATCH 0/8] x86: unifying ways to handle multiple sets of dma mapping ops
