Return-Path: <linux-kernel-owner+w=401wt.eu-S1754498AbYHKQfI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498AbYHKQfI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 12:35:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751330AbYHKQe6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 12:34:58 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:34690 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751211AbYHKQe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 12:34:57 -0400
Date: Mon, 11 Aug 2008 11:34:56 -0500
From: Dimitri Sivanich <sivanich@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Max Krasnyansky <maxk@qualcomm.com>
Subject: Re: [PATCH] x86: Remove EXPERIMENTAL restriction from CONFIG_HOTPLUG_CPU
Message-ID: <20080811163456.GC8181@sgi.com>
References: <20080811154646.GB8181@sgi.com> <20080811163111.GD4524@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080811163111.GD4524@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2008 at 06:31:11PM +0200, Ingo Molnar wrote:
> 
> So i've clarified the text as per the commit below - is this fine with 
> you?
> 

Yes, the text looks OK to me.
