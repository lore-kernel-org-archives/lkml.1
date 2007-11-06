Return-Path: <linux-kernel-owner+w=401wt.eu-S1757198AbXKFEAh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757198AbXKFEAh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 23:00:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755181AbXKFEAa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 23:00:30 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:56463 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754258AbXKFEA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 23:00:29 -0500
Date: Mon, 5 Nov 2007 20:00:28 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: WANG Cong <xiyou.wangcong@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
       Andrew Morton <akpm@osdl.org>, Dong Pu <cocobear.cn@gmail.com>
Subject: Re: [git Patch] mm/util.c: Remove needless code
In-Reply-To: <20071106031207.GA2478@hacking>
Message-ID: <Pine.LNX.4.64.0711051958380.23689@schroedinger.engr.sgi.com>
References: <20071106031207.GA2478@hacking>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Nov 2007, WANG Cong wrote:


> If the code can be executed there, 'new_size' is always larger
> than 'ks'. Thus min() is needless.

Correct.

Acked-by: Christoph Lameter <clameter@sgi.com>
