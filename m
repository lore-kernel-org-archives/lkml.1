Return-Path: <linux-kernel-owner+w=401wt.eu-S1765327AbYEOVst@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765327AbYEOVst (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 17:48:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756917AbYEOVsl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 17:48:41 -0400
Received: from mtagate7.uk.ibm.com ([195.212.29.140]:50908 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904AbYEOVsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 17:48:40 -0400
Date: Fri, 16 May 2008 00:53:15 +0300
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       alexisb@us.ibm.com
Subject: Re: [PATCH 0/2] x86: per-device dma_mapping_ops
Message-ID: <20080515215315.GG10434@il.ibm.com>
References: <87y76cym96.fsf@basil.nowhere.org> <20080515181619R.tomof@acm.org> <482C02A4.80101@firstfloor.org> <20080515184126O.tomof@acm.org> <20080515152631.GG6778@il.ibm.com> <20080515210340.GC318@one.firstfloor.org> <20080515213946.GE10434@il.ibm.com> <482CAEE6.5080509@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <482CAEE6.5080509@firstfloor.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2008 at 11:45:10PM +0200, Andi Kleen wrote:

> Even rare cases need to be handled.

Sure, but I'd rather we handle the common case first.

> In the nodma bitmap case it was the same always btw.

Not sure what you mean?

Cheers,
Muli
