Return-Path: <linux-kernel-owner+w=401wt.eu-S1753851AbXJAL5b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851AbXJAL5b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 07:57:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751710AbXJAL5X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 07:57:23 -0400
Received: from one.firstfloor.org ([213.235.205.2]:37930 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912AbXJAL5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 07:57:23 -0400
Date: Mon, 1 Oct 2007 13:57:21 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Denys <nuclearcat@nuclearcat.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.21 -> 2.6.22 & 2.6.23-rc8 performance regression
Message-ID: <20071001115721.GB17357@one.firstfloor.org>
References: <20070930144443.M52139@visp.net.lb> <46FFE17C.9020202@cosmosbay.com> <200709301425.37564.nickpiggin@yahoo.com.au> <20070930220452.M25621@nuclearcat.com> <p73myv36tmz.fsf@bingen.suse.de> <20071001103026.M59805@nuclearcat.com> <20071001111441.GA17357@one.firstfloor.org> <20071001114715.M51349@nuclearcat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071001114715.M51349@nuclearcat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 01, 2007 at 02:52:03PM +0300, Denys wrote:
> Hi
> 
> No major differences. 
> Some procedures higher a bit, some lower a bit, but everything looks fine on
> both kernels.
> 
> Thats what i tried first - oprofile, and only one keypoint i was able to catch
> - in top softirqd/0 or /1 shows usage 100% cpu, and in mpstat - soft% also
> reaching 100%. 

Then you likely just have higher load. What makes you think this
is a kernel problem?

-Andi
