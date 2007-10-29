Return-Path: <linux-kernel-owner+w=401wt.eu-S1758004AbXJ2O0Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758004AbXJ2O0Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 10:26:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754093AbXJ2O0D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 10:26:03 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:52103 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754010AbXJ2O0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 10:26:01 -0400
Date: Mon, 29 Oct 2007 07:21:29 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Toralf =?UTF-8?B?RsO2cnN0ZXI=?= <toralf.foerster@gmx.de>,
       linux-kernel@vger.kernel.org, cpufreq@www.linux.org.uk
Subject: Re: cpu governor ondemand issue
Message-ID: <20071029072129.653fe170@laptopd505.fenrus.org>
In-Reply-To: <20071029000243.9101d363.akpm@linux-foundation.org>
References: <200710211316.14955.toralf.foerster@gmx.de>
	<20071029000243.9101d363.akpm@linux-foundation.org>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Oct 2007 00:02:43 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> 
> And 2.6.23 was OK?
> 
> Is this problem still present in Linus's current tree?

and did you enable the "ignore nice levels" switch in sysfs ondemand
directory?

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
