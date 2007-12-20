Return-Path: <linux-kernel-owner+w=401wt.eu-S1756749AbXLTSxh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756749AbXLTSxh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 13:53:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753498AbXLTSxZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 13:53:25 -0500
Received: from relay2.sgi.com ([192.48.171.30]:44463 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752973AbXLTSxY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 13:53:24 -0500
From: akepner@sgi.com
Date: Thu, 20 Dec 2007 10:51:54 -0800
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, grundler@parisc-linux.org,
       jbarnes@virtuousgeek.org, jes@sgi.com, randy.dunlap@oracle.com,
       rdreier@cisco.com, James.Bottomley@steeleye.com, davem@davemloft.net,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] dma: passing "attributes" to dma_map_* routines
Message-ID: <20071220185154.GK412@sgi.com>
References: <20071218001758.GO21916@sgi.com> <4767FA62.9060002@s5r6.in-berlin.de> <20071218200759.GE412@sgi.com> <476834AC.9050401@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <476834AC.9050401@s5r6.in-berlin.de>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2007 at 09:59:24PM +0100, Stefan Richter wrote:

> ....
> So that would be option 3) of yours, though without your attrs
> parameter.  Do you expect the need for even more flags for other kinds
> of special behavior?

I was hoping to keep the option of adding additional 
flags, but for now there's no obvious need for other
flags that I'm aware of.

-- 
Arthur

