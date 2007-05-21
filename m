Return-Path: <linux-kernel-owner+w=401wt.eu-S1758783AbXEUNjg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758783AbXEUNjg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 09:39:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755382AbXEUNj3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 09:39:29 -0400
Received: from gw.goop.org ([64.81.55.164]:42565 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755323AbXEUNj2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 09:39:28 -0400
Message-ID: <4651A113.9020300@goop.org>
Date: Mon, 21 May 2007 14:39:31 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Sam Ravnborg <sam@ravnborg.org>, Andrey Borzenkov <arvidjaar@mail.ru>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: fix section mismatch warnings in mtrr
References: <200705191443.27161.arvidjaar@mail.ru> <20070519133257.GB23370@uranus.ravnborg.org> <200705191555.49376.ak@suse.de>
In-Reply-To: <200705191555.49376.ak@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> On Saturday 19 May 2007 15:32, Sam Ravnborg wrote:
>   
>> Following section mismatch warnings were reported by Andrey Borzenkov:
>>     
>
> In what configuration? I don't see this.

I'm pretty sure I made those functions __init when I cleaned up that
code.  Did those pieces of the patch get mislayed?  I thought it made it
into upstream.

    J
