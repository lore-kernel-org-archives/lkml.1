Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389Ab0BEIeg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 03:34:36 -0500
Received: from gir.skynet.ie ([193.1.99.77]:44236 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753644Ab0BEIef (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 03:34:35 -0500
Date: Fri, 5 Feb 2010 08:34:22 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: Ingo Molnar <mingo@elte.hu>
cc: Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>, dri-devel@lists.sf.net,
       Alex Deucher <alexdeucher@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org
Subject: Re: hung bootup with "drm/radeon/kms: move radeon KMS on/off switch
 out of staging."
In-Reply-To: <20100205075645.GF9320@elte.hu>
Message-ID: <alpine.DEB.2.00.1002050832450.2995@skynet.skynet.ie>
References: <20100204181218.GA6175@elte.hu> <a728f9f91002041030o7c8d38edxe573bc0a1327d79@mail.gmail.com> <20100204190649.GB6665@elte.hu> <a728f9f91002041118m6415844fp1740f18fdc1c9757@mail.gmail.com> <20100204193232.GD6665@elte.hu> <20100204115316.69beee75@jbarnes-piketon>
 <20100204202254.GA24716@elte.hu> <20100204204829.GA24608@srcf.ucam.org> <20100204210559.GC19050@elte.hu> <20100204210950.GA25295@srcf.ucam.org> <20100205075645.GF9320@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> If it now does not boot up if all its sub-options are enabled, even of some 
> of those sub-options are new, does that count as a driver regression? Sure it 
> does to me ...

But it doesn't to anyone else under any reasonable meaning of the word 
regression. 

The config option states
"Choose this option if you want kernel modesetting enabled by default,
          and you have a new enough userspace to support this. Running old
          userspaces with this enabled will cause pain."

Will cause pain sounds painful to me, I can make it seem much worse if 
you'd like.

Dave.
