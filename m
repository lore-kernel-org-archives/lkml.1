Return-Path: <linux-kernel-owner+w=401wt.eu-S1754832AbYAGE4s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754832AbYAGE4s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 23:56:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753596AbYAGE4j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 23:56:39 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:42215 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753521AbYAGE4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 23:56:38 -0500
Date: Sun, 6 Jan 2008 20:55:57 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Olof Johansson <olof@lixom.net>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       heiko.carstens@de.ibm.com, mingo@elte.hu, mpm@selenic.com
Subject: Re: [PATCH] Add bug/warn marker to generic report_bug()
Message-ID: <20080106205557.5b26f3bf@laptopd505.fenrus.org>
In-Reply-To: <20080107012237.GA16790@lixom.net>
References: <20080105190713.73745ec6@laptopd505.fenrus.org>
	<20080106202223.GA12640@lixom.net>
	<20080106133817.4f42ab82@laptopd505.fenrus.org>
	<20080107012237.GA16790@lixom.net>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 Jan 2008 19:22:37 -0600
Olof Johansson <olof@lixom.net> wrote:


> This comment in oops_enter threw me off of using it:
> 
>         debug_locks_off(); /* can't trust the integrity of the kernel
> 	anymore */
> 
> Since we can very well depend on the integrity of the kernel when it's
> just doing a __WARN().

ok fair enough; objection withdrawn

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
