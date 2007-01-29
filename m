Return-Path: <linux-kernel-owner+w=401wt.eu-S1750912AbXA2Q3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750912AbXA2Q3T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 11:29:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751441AbXA2Q3S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 11:29:18 -0500
Received: from twin.jikos.cz ([213.151.79.26]:37162 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750912AbXA2Q3S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 11:29:18 -0500
Date: Mon, 29 Jan 2007 17:28:53 +0100 (CET)
From: Jiri Kosina <jikos@jikos.cz>
To: Thomas Gleixner <tglx@linutronix.de>
cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.20-rc6-mm2
In-Reply-To: <1170085218.29240.1.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0701291723240.9448@twin.jikos.cz>
References: <20070129001207.71ea3470.akpm@osdl.org> 
 <Pine.LNX.4.64.0701291122570.9448@twin.jikos.cz> <1170085218.29240.1.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Jan 2007, Thomas Gleixner wrote:

> > I guess that it's caused by some timer changes (added Thomas and Ingo to 
> > CC), which confuse the softlockup detector sense of time? 
> Does the patch below fix this ?

It does.

Acked-by: Jiri Kosina <jkosina@suse.cz>

-- 
Jiri Kosina
