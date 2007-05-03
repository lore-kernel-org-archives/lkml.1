Return-Path: <linux-kernel-owner+w=401wt.eu-S1161929AbXECNzg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161929AbXECNzg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 09:55:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161930AbXECNzg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 09:55:36 -0400
Received: from fb1.tech.numericable.fr ([82.216.111.51]:40238 "EHLO
	fb1.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161929AbXECNzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 09:55:35 -0400
X-Greylist: delayed 1561 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 May 2007 09:55:35 EDT
Date: Thu, 3 May 2007 15:29:32 +0200
From: Damien Wyart <damien.wyart@free.fr>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch] CFS scheduler, -v8
Message-ID: <20070503132932.GA4204@localhost.localdomain>
References: <46399B51.9040608@dunaweb.hu> <20070503130201.GA9000@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070503130201.GA9000@elte.hu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

* Ingo Molnar <mingo@elte.hu> [2007-05-03 15:02]:
> great! So it seems -v8 does improve OpenGL handling too :-)

What are your thoughts/plans concerning merging CFS into mainline ? Is
it a bit premature to get it into 2.6.22 ? I remember Linus was ok to
change the default scheduler rapidly (the discussion was about sd at
that time) to get more testing than in -mm.

-- 
Damien Wyart
