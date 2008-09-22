Return-Path: <linux-kernel-owner+w=401wt.eu-S1754724AbYIVX2g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724AbYIVX2g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 19:28:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753589AbYIVX23
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 19:28:29 -0400
Received: from xenotime.net ([66.160.160.81]:57573 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753860AbYIVX22 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 19:28:28 -0400
Date: Mon, 22 Sep 2008 16:28:23 -0700 (PDT)
From: "Randy.Dunlap" <rdunlap@xenotime.net>
X-X-Sender: rddunlap@shark.he.net
To: Arjan van de Ven <arjan@infradead.org>
cc: linux-kernel@vger.kernel.org, mingo@elte.hu,
       Hugh Dickins <hugh@veritas.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 2/2] corruption check: run the corruption checks from a
 work queue
In-Reply-To: <20080922162426.2a55a722@infradead.org>
Message-ID: <Pine.LNX.4.64.0809221627290.4768@shark.he.net>
References: <20080920203544.53a5148e@infradead.org> <20080922140402.166de1ba@infradead.org>
 <20080922140503.5f3a3db3@infradead.org> <20080922162426.2a55a722@infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Sep 2008, Arjan van de Ven wrote:

> eh a stray debug // snuck in; update attached

In that case, patch 1/2 contains "for(" and "while(".  :(

-- 
~Randy
