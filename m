Return-Path: <linux-kernel-owner+w=401wt.eu-S1760675AbYCDOh7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760675AbYCDOh7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 09:37:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754417AbYCDOhu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 09:37:50 -0500
Received: from lazybastard.de ([212.112.238.170]:33912 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753114AbYCDOht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 09:37:49 -0500
Date: Tue, 4 Mar 2008 15:36:48 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Adrian Bunk <bunk@kernel.org>, Sam Ravnborg <sam@ravnborg.org>,
       Alexey Starikovskiy <aystarik@gmail.com>, lenb@kernel.org,
       astarikovskiy@suse.de, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [2.6 patch] acpi/battery.c: make 2 functions static
Message-ID: <20080304143648.GA27484@lazybastard.org>
References: <20080303113451.GF4457@cs181133002.pp.htv.fi> <20080303114533.GA4183@elte.hu> <20080303120211.GG4457@cs181133002.pp.htv.fi> <20080303121015.GA12660@elte.hu> <20080303122953.GH4457@cs181133002.pp.htv.fi> <20080303125027.GA21577@elte.hu> <20080303145413.GA26072@cs181133002.pp.htv.fi> <20080304131600.GG29777@elte.hu> <20080304134701.GA20278@cs181133002.pp.htv.fi> <20080304142248.GA2201@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080304142248.GA2201@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 March 2008 15:22:48 +0100, Ingo Molnar wrote:
> 
> do you mean this paragraph:

Could you two please refrain from sending any more of this?  Who said
what when and where doesn't help anyone, not even either of your ego's
or hurt feelings.

A huge paperbag bug was found and I'm happy it's gone.  It could and
should have been fixed long ago.  As for personal motives, I just
couldn't care less.  And this thread has devolved way beyond a
metadiscussion about motives.

Jörn

-- 
Debugging is twice as hard as writing the code in the first place.
Therefore, if you write the code as cleverly as possible, you are,
by definition, not smart enough to debug it.
-- Brian W. Kernighan
