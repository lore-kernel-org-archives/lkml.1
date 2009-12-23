Return-Path: <linux-kernel-owner+w=401wt.eu-S1756303AbZLWQVZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756303AbZLWQVZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 11:21:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756223AbZLWQVY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 11:21:24 -0500
Received: from k66.ru ([87.224.128.21]:58891 "EHLO k66.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756140AbZLWQVW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 11:21:22 -0500
Date: Wed, 23 Dec 2009 21:21:17 +0500
From: Andrey Rahmatullin <wrar@wrar.name>
To: Jarek Poplawski <jarkao2@gmail.com>
Cc: Roger Luethi <rl@hellgate.ch>, Christian Kujau <lists@nerdbynature.de>,
       LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Subject: Re: via_rhine kernel crashes in 2.6.32
Message-ID: <20091223162117.GA4919@wrars-comp.wrarsdomain>
References: <20091222152658.GA16043@core.hellgate.ch>
 <20091223095203.GA7824@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20091223095203.GA7824@ff.dom.local>
X-Operating-System: ALT Linux Sisyphus
X-Jabber-Id: wrar@altlinux.org
User-Agent: Mutt/1.5.20 (2009-06-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 23, 2009 at 09:52:03AM +0000, Jarek Poplawski wrote:
> BTW, it seems a change in 2.6.31 might trigger these timeouts more
> often than before. Andrey, could you try if this matters here?
They appear once per 4 seconds with or without this patch.

-- 
WBR, wRAR (ALT Linux Team)
