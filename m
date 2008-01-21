Return-Path: <linux-kernel-owner+w=401wt.eu-S1758646AbYAUKCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758646AbYAUKCV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 05:02:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758761AbYAUKBy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 05:01:54 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:52384 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758665AbYAUKBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 05:01:54 -0500
Date: Mon, 21 Jan 2008 10:01:51 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Roland Dreier <rdreier@cisco.com>
Cc: linux-kernel@vger.kernel.org, general@lists.openfabrics.org
Subject: Re: InfiniBand/RDMA merge plans for 2.6.25
Message-ID: <20080121100151.GD5333@infradead.org>
References: <ada7ii8xaao.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ada7ii8xaao.fsf@cisco.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2008 at 04:11:11PM -0800, Roland Dreier wrote:
>  - Neteffect "nes" driver.  It's not terribly clean code but since
>    it's a new driver that is completely self-contained, I plan on
>    merging it and letting cleanups happen upstream.

New code should be better quality than old code, not worse.   I haven't
actually seen the driver yet, but by that statement I'd be clearly
against a merge.

