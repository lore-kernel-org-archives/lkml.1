Return-Path: <linux-kernel-owner+w=401wt.eu-S1758213AbZCJRrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758213AbZCJRrW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 13:47:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757222AbZCJRrI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 13:47:08 -0400
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:44607 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757032AbZCJRrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 13:47:07 -0400
Date: Tue, 10 Mar 2009 17:46:27 +0000
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Asking for inclusion of nilfs2 in the mainline kernel
Message-ID: <20090310174627.GA10667@silver.sucs.org>
References: <20090311.015542.118514963.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090311.015542.118514963.ryusuke@osrg.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Mar 11, 2009 at 01:55:42AM +0900, Ryusuke Konishi wrote:
>  # lscp
>  (list checkpoints)
> 
>             CNO        DATE     TIME  MODE  FLG   NBLKINC       ICNT
>           33338  2009-03-08 14:45:49   cp    -         11          3
>           33339  2009-03-08 14:50:22   cp    -     200523         81
>           33340  2009-03-08 20:40:34   cp    -        136         61
>           33341  2009-03-08 20:41:20   cp    -     187666       1604
>           33342  2009-03-08 20:41:42   cp    -         51       1634
>             ...

Is there a cheaty way to get at checkpointed files (and the list of
checkpoints) through some sort of magic dot directory system (so you
wouldn't need the userland tools and the remounting)?

-- 
Sitsofe | http://sucs.org/~sits/
