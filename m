Return-Path: <linux-kernel-owner+w=401wt.eu-S1753153AbZHTCho@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753153AbZHTCho (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 22:37:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752622AbZHTChn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 22:37:43 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:35317 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752533AbZHTChn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 22:37:43 -0400
Date: Thu, 20 Aug 2009 12:37:41 +1000
From: Simon Horman <horms@verge.net.au>
To: Ryo Tsuruta <ryov@valinux.co.jp>
Cc: agk@redhat.com, dm-devel@redhat.com, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org,
       xen-devel@lists.xensource.com
Subject: Re: [PATCH] dm-ioband-v1.12.3: I/O bandwidth controller
Message-ID: <20090820023740.GA12528@verge.net.au>
References: <20090731.130333.104034609.ryov@valinux.co.jp>
 <20090807.103640.104065157.ryov@valinux.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090807.103640.104065157.ryov@valinux.co.jp>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 07, 2009 at 10:36:40AM +0900, Ryo Tsuruta wrote:
> Hi Alasdair,
> 
> Ryo Tsuruta <ryov@valinux.co.jp> wrote:
> > Hi Alasdair,
> > 
> > This is dm-ioband v1.12.3 release that is a minor update to avoid
> > sparse warnings other than related to the event tracing. (I used
> > sparse-2009-07-29.)
> > 
> > This patch can be applied to the current dm-devel tree and 2.6.31-rc4,
> > so could you please replace dm-add-ioband.patch in your tree with this?
> > And I would appreciate it if you would let me know your thoughts about
> > merging dm-ioband to upstream.
> 
> The dm-ioband patch in the dm-devel tree is still older. Could you
> please update it with the new patch? And could you please let me know
> your thoughts about dm-ioband?

Hi Alasdiar,

I'm wondering if you see any problems with merging dm-ioband at this time.
I'm eager to address any such concerns.

