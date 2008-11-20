Return-Path: <linux-kernel-owner+w=401wt.eu-S1756892AbYKTT0X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756892AbYKTT0X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 14:26:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755212AbYKTT0P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 14:26:15 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:53562 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753756AbYKTT0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 14:26:15 -0500
Date: Thu, 20 Nov 2008 14:26:12 -0500
From: Christoph Hellwig <hch@infradead.org>
To: david safford <safford@watson.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>,
       Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@liux-foundation.org>,
       James Morris <jmorris@namei.org>, Al Viro <viro@ZenIV.linux.org.uk>,
       Serge Hallyn <serue@linux.vnet.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
Subject: Re: [PATCH 2/4] integrity: Linux Integrity Module(LIM)
Message-ID: <20081120192612.GA15080@infradead.org>
References: <cover.1227137423.git.zohar@linux.vnet.ibm.com> <ece5bb6863d9b42016860f3ef78656e4a228ad95.1227137423.git.zohar@linux.vnet.ibm.com> <20081120174506.GA20972@infradead.org> <1227208898.3066.36.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1227208898.3066.36.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2008 at 02:21:38PM -0500, david safford wrote:
> The consensus in the (insane) security community was to have an
> interface with selectable modules similar to LSM and its modules,
> so that users could easily choose among a set of integrity providers.

So what other integrity provider is there waiting to be merged?  Unless
there is a realistic mid-term candidate it's just pure bloat, and we
can introduce an abstraction once it's actually needed.

