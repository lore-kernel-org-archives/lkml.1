Return-Path: <linux-kernel-owner+w=401wt.eu-S1755715AbXFTNbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755715AbXFTNbT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 09:31:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751269AbXFTNbM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 09:31:12 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:59995 "EHLO
	viefep15-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751144AbXFTNbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 09:31:12 -0400
Date: Wed, 20 Jun 2007 15:31:12 +0200
From: Carlo Wood <carlo@alinoe.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
       eric@anholt.net, zhenyu.z.wang@intel.com, lethal@linux-sh.org,
       y-goto@jp.fujitsu.com
Subject: Re: 2.6.22-rc5 regression
Message-ID: <20070620133112.GA24806@alinoe.com>
Mail-Followup-To: Carlo Wood <carlo@alinoe.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
	eric@anholt.net, zhenyu.z.wang@intel.com, lethal@linux-sh.org,
	y-goto@jp.fujitsu.com
References: <alpine.LFD.0.98.0706180950130.14121@woody.linux-foundation.org> <20070618181225.GB8054@alinoe.com> <alpine.LFD.0.98.0706181127380.14121@woody.linux-foundation.org> <20070618195415.GA7481@alinoe.com> <alpine.LFD.0.98.0706181332400.3593@woody.linux-foundation.org> <20070618225009.GE13538@alinoe.com> <alpine.LFD.0.98.0706181553450.3593@woody.linux-foundation.org> <20070619233716.GA5779@alinoe.com> <alpine.LFD.0.98.0706191649160.3593@woody.linux-foundation.org> <20070620131120.GA17615@alinoe.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070620131120.GA17615@alinoe.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2007 at 03:11:20PM +0200, Carlo Wood wrote:
> 2.6.22-rc5 BAD
> 2.6.22-rc4+somethingelse BAD
> 2.6.22-rc4+something GOOD
> 2.6.22-rc4 BAD
> ...
> 2.6.18-rc1 BAD
> 2.6.18 GOOD

Ok, that made no sense. I meant:

> 2.6.19-rc1 BAD
> 2.6.18 GOOD

-- 
Carlo Wood <carlo@alinoe.com>
