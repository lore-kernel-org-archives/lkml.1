Return-Path: <linux-kernel-owner+w=401wt.eu-S1752105AbYIVGuZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752105AbYIVGuZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 02:50:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751317AbYIVGuM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 02:50:12 -0400
Received: from pih-relay05.plus.net ([212.159.14.18]:45534 "EHLO
	pih-relay05.plus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225AbYIVGuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 02:50:11 -0400
Message-ID: <48D74027.7020708@yahoo.com>
Date: Mon, 22 Sep 2008 07:50:15 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
User-Agent: Thunderbird 2.0.0.16 (Macintosh/20080707)
MIME-Version: 1.0
To: Matt Keenan <tank.en.mate@gmail.com>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: How how latent should non-preemptive scheduling be?
References: <48D1741A.7010508@yahoo.com> <1222030615.10469.10.camel@bazbox>
In-Reply-To: <1222030615.10469.10.camel@bazbox>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Plusnet-Relay: e805ab8aab8d3d2c56d7e488fcb5dffe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Keenan wrote:
> If you use ALSA you could write a custom .asoundrc file and increase
> ALSA's default buffer size, this gives the hardware a longer buffer to
> play which may work around the problem. This used to do the trick for me
> with the old scheduler with slow machines. Not a fix but if nothing else
> works...

In all fairness turning on preemption also helps (I don't hear any drops 
or see any stalls once it's on) but I'm trying to work out if this is an 
underlying problem that can be fixed (and then there is the case of the 
default desktop distros).

-- 
Sitsofe | http://sucs.org/~sits/
