Return-Path: <linux-kernel-owner+w=401wt.eu-S1762963AbXEPQqj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762963AbXEPQqj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 12:46:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762870AbXEPQq1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 12:46:27 -0400
Received: from lazybastard.de ([212.112.238.170]:50480 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762790AbXEPQq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 12:46:26 -0400
Date: Wed, 16 May 2007 18:41:59 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
       Albert Cahalan <acahalan@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Greg KH <greg@kroah.com>,
       Ingo Oeser <ioe-lkml@rameria.de>
Subject: Re: [PATCH] LogFS take three
Message-ID: <20070516164158.GB8113@lazybastard.org>
References: <20070515151919.GA32510@lazybastard.org> <20070515133759.9ee434a2.akpm@linux-foundation.org> <1179317240.2859.222.camel@shinybook.infradead.org> <20070516083408.dcd9dd78.akpm@linux-foundation.org> <1179330596.2859.248.camel@shinybook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1179330596.2859.248.camel@shinybook.infradead.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 May 2007 23:49:55 +0800, David Woodhouse wrote:
> 
> Utility is a factor of the underlying design -- a filesystem designed
> for flash really isn't suited to block devices.

I can think of at least three examples where LogFS would indeed make
sense on block devices.

Jörn

-- 
Happiness isn't having what you want, it's wanting what you have.
-- unknown
