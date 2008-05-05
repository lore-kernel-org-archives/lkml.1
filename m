Return-Path: <linux-kernel-owner+w=401wt.eu-S1753422AbYEEEgK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422AbYEEEgK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 00:36:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751228AbYEEEf6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 00:35:58 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:43191 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898AbYEEEf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 00:35:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=hUGK15lwO5oF8HJefn6+FWKCyG4x8GRZmmTcRDJXX+DZWrp7e/iJLgsTH9sZDD6tr7qMUnsDVhqG3AUlSGwg3lp6poOMoRe+lvqBGc9Ni9IBvQsLMQ2UIg13lBuU6pbOZ6KJmfCpWnG9t6yrnphd/KHBSVzvOX1Vwj37JxOImiM=
Date: Mon, 5 May 2008 00:35:55 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Stas Sergeev <stsp@aknet.ru>
Cc: Takashi Iwai <tiwai@suse.de>, Linux kernel <linux-kernel@vger.kernel.org>,
       Vojtech Pavlik <vojtech@suse.cz>,
       Michael Opdenacker <michael-lists@free-electrons.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch][resend] pcspkr: fix dependancies
Message-ID: <20080505043554.GC11584@anvil.corenet.prv>
References: <481D3A08.2040500@aknet.ru> <20080505035733.GA11584@anvil.corenet.prv> <481E8C64.7090507@aknet.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <481E8C64.7090507@aknet.ru>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 05, 2008 at 08:26:12AM +0400, Stas Sergeev wrote:
> Hello.
> 
> Dmitry Torokhov wrote:
> >> Dmitry, would you mind applying this one?
> >> If not, then I see no way to get either
> >> fix applied...
> > Ok, but don't you need to also add the same dependancy for SND_PCSP?
> Thanks!
> As for SND_PCSP - I decided to skip
> that part and send it as a separate
> patch to Takashi, when this one is
> settled. Otherwise it would be even
> more difficult to find the right person
> to apply the whole thing. :)

Why don't we ask Takashi to apply it in one step? You can add my

	Acked-by: Dmitry Torokhov <dtor@mail.ru>

-- 
Dmitry
