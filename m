Return-Path: <linux-kernel-owner+w=401wt.eu-S1752799AbZIIJdE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799AbZIIJdE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 05:33:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751753AbZIIJdE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 05:33:04 -0400
Received: from mga06.intel.com ([134.134.136.21]:44711 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751779AbZIIJdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 05:33:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,357,1249282800"; 
   d="scan'208";a="549007871"
Date: Wed, 9 Sep 2009 11:35:02 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Walleij <linus.ml.walleij@gmail.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       Russell King <linux@arm.linux.org.uk>,
       Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [PATCH 1/2] AB3100 regulator support v4
Message-ID: <20090909093500.GC4292@sortiz.org>
References: <1251982396-23790-1-git-send-email-linus.walleij@stericsson.com>
 <1251987348.6735.49.camel@odin>
 <63386a3d0909081507n7071761fyb7c8350072129fcd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <63386a3d0909081507n7071761fyb7c8350072129fcd@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Wed, Sep 09, 2009 at 12:07:05AM +0200, Linus Walleij wrote:
> 009/9/3 Liam Girdwood <lrg@slimlogic.co.uk>:
> 
> > Samuel, are you happy for this to go via mfd for simpler merging ?
> > If so :-
> >
> > Signed-off-by: Liam Girdwood <lrg@slimlogic.co.uk>
> 
> OK with you Sam?
Yes, applied to my for-next branch. There were a couple checkpatch 80+
character line length warnings, but I'm not that picky :)

Cheers,
Samuel.


> Linus Walleij

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
