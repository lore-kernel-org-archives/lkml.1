Return-Path: <linux-kernel-owner+w=401wt.eu-S1753361AbXIST0K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361AbXIST0K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 15:26:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750985AbXISTZ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 15:25:57 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:4813 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727AbXISTZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 15:25:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=gUAsKBwpHKBDCM4nau+sdwz8xaHGRONL049JM5xK3iSTG7TlICUIln1WX5uZrK3qspSm0DlbQyLXs7qy/dBd/6ZrVpSKqIDTJ+opByPQnEYO7lWE15b0huSKl6vtcrCK4tI6SHAsKj1IuGDytGlvKR7SyECc2DwDbIeGT9rWyNs=
Date: Wed, 19 Sep 2007 22:25:46 +0300
To: Low Yucheng <ylow@andrew.cmu.edu>
Cc: Oleg Verych <olecom@flower.upol.cz>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: PROBLEM: System Freeze on Particular workload with kernel 2.6.22.6
Message-ID: <20070919192546.GA3153@Ahmed>
References: <46F0E19D.8000400@andrew.cmu.edu> <E1IY1mO-00067S-7v@flower> <46F14B67.5010807@andrew.cmu.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46F14B67.5010807@andrew.cmu.edu>
User-Agent: Mutt/1.5.11
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Low,

On Wed, Sep 19, 2007 at 12:16:39PM -0400, Low Yucheng wrote:
> There are no additional console messages.
> Not sure what this is: * no relevant Cc (memory management added)

Relevant CCs means CCing maintainers or subsystem mailing lists related to your
bug report. i.e, if it's a networking bug, you need to CC the linux kernel
networking mailing list. If it's a kobject bug, you need to CC its maintainer
(Greg) and so on.

Regards,  

-- 
Ahmed S. Darwish
HomePage: http://darwish.07.googlepages.com
Blog: http://darwish-07.blogspot.com
