Return-Path: <linux-kernel-owner+w=401wt.eu-S1762840AbXKNAxX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762840AbXKNAxX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 19:53:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760438AbXKNAxL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 19:53:11 -0500
Received: from mx1.redhat.com ([66.187.233.31]:57099 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759740AbXKNAxI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 19:53:08 -0500
Message-ID: <473A46C1.3060000@redhat.com>
Date: Tue, 13 Nov 2007 19:52:17 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Adrian Bunk <bunk@kernel.org>, Mark Lord <liml@rtr.ca>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, protasnb@gmail.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       alsa-devel@alsa-project.org, linux-ide@vger.kernel.org,
       linux-pcmcia@lists.infradead.org, linux-input@atrey.karlin.mff.cuni.cz,
       bugme-daemon@bugzilla.kernel.org
Subject: Re: [BUG] New Kernel Bugs
References: <20071113134029.GA30978@elte.hu>	<4739AFE0.20705@rtr.ca>	<20071113164650.GA28493@elte.hu>	<4739E3D0.10201@rtr.ca>	<20071113181228.GF4250@stusta.de>	<4739EA83.5040006@rtr.ca>	<20071113183605.GG4250@stusta.de>	<4739F12E.5020807@rtr.ca>	<20071113190428.GH4250@stusta.de>	<4739FA4D.1050900@rtr.ca>	<20071113200028.GJ4250@stusta.de> <20071113211256.1d18fe1a@the-village.bc.nu>
In-Reply-To: <20071113211256.1d18fe1a@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2007 04:12 PM, Alan Cox wrote:
>> Bug fixing is not about finding someone to blame, it's about getting the 
>> bug fixed.
> 
> Partly - its also about understanding why the bug occurred and making it
> not happen again.

Very few people think about that part.
