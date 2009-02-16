Return-Path: <linux-kernel-owner+w=401wt.eu-S1757925AbZBPOAt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757925AbZBPOAt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 09:00:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755087AbZBPOAk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 09:00:40 -0500
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:56278 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965AbZBPOAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 09:00:39 -0500
Message-ID: <4999717F.7090205@s5r6.in-berlin.de>
Date: Mon, 16 Feb 2009 15:00:31 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.19) Gecko/20081204 SeaMonkey/1.1.14
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Sam Ravnborg <sam@ravnborg.org>, Manish Katiyar <mkatiyar@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] Remove errors caught by checkpatch.pl in	kernel/kallsyms.c
References: <ea11fea30902151034s5444efabw455c1dac1b875086@mail.gmail.com> <20090215184752.GA4970@uranus.ravnborg.org> <4999650C.6030700@s5r6.in-berlin.de> <20090216132822.GC17996@elte.hu>
In-Reply-To: <20090216132822.GC17996@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
>> Furthermore, the changelog is bad (non-exiting in fact).
>> 
>> The fact that the issues where discovered using checkpatch is absolutely
>> uninteresting.  The changelog should describe /what/ is fixed, [...]
> 
> The commit log definitely needs enhancements but it's not uninteresting 
> at all what tools were used to arrive to a change. [...] if a
> good and acceptable commit results out of a tool's usage then that tool 
> needs to be advertised some more.)

Fine, then the author could mention it below the --- delimitor in the
patch posting.  The changelog however, as annotation of the source
history, is not a billboard.  We also don't describe for example that a
nice cup of hot Earl Grey or whatever was vital to the creation of a patch.
-- 
Stefan Richter
-=====-==--= --=- =----
http://arcgraph.de/sr/
