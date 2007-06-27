Return-Path: <linux-kernel-owner+w=401wt.eu-S1760681AbXF0Mj2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760681AbXF0Mj2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 08:39:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756682AbXF0MjS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 08:39:18 -0400
Received: from smtpout.mac.com ([17.250.248.184]:59214 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756340AbXF0MjR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 08:39:17 -0400
In-Reply-To: <20070626111414.GA9352@wotan.suse.de>
References: <20070624014528.GA17609@wotan.suse.de> <20070626030640.GM989688@sgi.com> <46808E1F.1000509@yahoo.com.au> <20070626092309.GF31489@sgi.com> <20070626111414.GA9352@wotan.suse.de>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <05245412-9053-408B-900E-19DCF0D8BBEA@mac.com>
Cc: David Chinner <dgc@sgi.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       linux-fsdevel@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: [RFC] fsblock
Date: Wed, 27 Jun 2007 08:39:08 -0400
To: Nick Piggin <npiggin@suse.de>
X-Mailer: Apple Mail (2.752.2)
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-scanned: yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 26, 2007, at 07:14:14, Nick Piggin wrote:
> On Tue, Jun 26, 2007 at 07:23:09PM +1000, David Chinner wrote:
>> Can we call it a block mapping layer or something like that? e.g.  
>> struct blkmap?
>
> I'm not fixed on fsblock, but blkmap doesn't grab me either. It is  
> a map from the pagecache to the block layer, but blkmap sounds like  
> it is a map from the block to somewhere.
>
> fsblkmap ;)

vmblock? pgblock?

Cheers,
Kyle Moffett

