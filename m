Return-Path: <linux-kernel-owner+w=401wt.eu-S1755975AbYAWFu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975AbYAWFu2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 00:50:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753274AbYAWFuU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 00:50:20 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:47253 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753263AbYAWFuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 00:50:19 -0500
Date: Wed, 23 Jan 2008 05:50:14 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Roland Dreier <rdreier@cisco.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org
Subject: Re: InfiniBand/RDMA merge plans for 2.6.25
Message-ID: <20080123055014.GA9256@infradead.org>
References: <ada7ii8xaao.fsf@cisco.com> <20080121100151.GD5333@infradead.org> <adad4rttthr.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adad4rttthr.fsf@cisco.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2008 at 01:56:00PM -0800, Roland Dreier wrote:
> be improved (sparse endianness annotation,

that's a blocker for sure.  No new code that's not sparse clean, please.

