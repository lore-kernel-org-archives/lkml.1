Return-Path: <linux-kernel-owner+w=401wt.eu-S1763471AbYARRVa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763471AbYARRVa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 12:21:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760122AbYARRVX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 12:21:23 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:55539 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759238AbYARRVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 12:21:22 -0500
Date: Fri, 18 Jan 2008 09:20:39 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, phil.el@wanadoo.fr,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: x86: Add support for the latest Intel processors to Oprofile
Message-ID: <20080118092039.13579105@laptopd505.fenrus.org>
In-Reply-To: <20080118123610.GK11044@elte.hu>
References: <20080117101613.65bf008b@laptopd505.fenrus.org>
	<20080118123610.GK11044@elte.hu>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jan 2008 13:36:11 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Arjan van de Ven <arjan@infradead.org> wrote:
> 
> > Subject: x86: Add support for the latest Intel processors to
> > Oprofile From: Arjan van de Ven <arjan@linux.intel.com>
> > 
> > The latest Intel processors (the 45nm ones) have a model number of
> > 23 (old ones had 15); they're otherwise compatible on the oprofile
> > side. This patch adds the new model number to the oprofile code.
> 
> thanks, applied.
> 
> 2.6.24 fix too, right?
> 

that's a judgement call ... it's sure simple enough

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
