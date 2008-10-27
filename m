Return-Path: <linux-kernel-owner+w=401wt.eu-S1753582AbYJ0HqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753582AbYJ0HqR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 03:46:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753020AbYJ0Hp7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 03:45:59 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:35125 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751800AbYJ0Hp5 (ORCPT
	<rfc822;@relay.corp.sgi.com:linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 03:45:57 -0400
Message-ID: <49057146.3000101@sgi.com>
Date: Mon, 27 Oct 2008 18:44:06 +1100
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, xfs@oss.sgi.com
Subject: Re: linux-next: left over things in linux-next after 2.6.28-c1
References: <20081026005009.50dbbb33.sfr@canb.auug.org.au> <20081026081717.GB20872@infradead.org> <20081026193421.f5f7d8f1.sfr@canb.auug.org.au> <20081026083939.GA19394@infradead.org>
In-Reply-To: <20081026083939.GA19394@infradead.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Sun, Oct 26, 2008 at 07:34:21PM +1100, Stephen Rothwell wrote:
>> Presumably what was merged was slightly different (or the commits were
>> split up differently).  This is the same problem I have with the kvm tree.
> 
> It should be the same, but the xfs trees have been a bit of a maze
> recently, so it shouldn't be a surprise that your list got out of sync.
> 

The XFS tree used for linux-next got a bit out of whack and I couldn't make
sense of the mess so I've been using a different tree for the mainline pull
requests.  We'll have this mess sorted out soon.
