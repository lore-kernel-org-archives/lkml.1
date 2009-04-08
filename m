Return-Path: <linux-kernel-owner+w=401wt.eu-S1765956AbZDHOxp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765956AbZDHOxp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 10:53:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757072AbZDHOx1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 10:53:27 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:53729 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750776AbZDHOxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 10:53:25 -0400
X-Sasl-enc: 5PrxfzKNOHz80qiyF9WkgXF/i5NIUpmYoWK7Eg0YhPCt 1239202404
Message-ID: <49DCBA61.8060507@fastmail.fm>
Date: Wed, 08 Apr 2009 15:53:21 +0100
From: Jack Stone <jwjstone@fastmail.fm>
User-Agent: Thunderbird 2.0.0.21 (X11/20090325)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Bert Wesarg <bert.wesarg@googlemail.com>, linux-kernel@vger.kernel.org,
       jeff@garzik.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 54/56] x86: Remove void casts
References: <1239189748-11703-52-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-53-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-54-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-55-git-send-email-jwjstone@fastmail.fm> <36ca99e90904080518qf81b483h6ed2bc9752ee0d1e@mail.gmail.com> <49DCAE97.8040602@fastmail.fm> <20090408140637.GC12931@elte.hu> <49DCB140.7000603@fastmail.fm> <20090408144055.GH12931@elte.hu> <49DCB8C5.4090108@fastmail.fm> <20090408144842.GK12931@elte.hu>
In-Reply-To: <20090408144842.GK12931@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> No, i mean, this approach should be changed, and i dont think any 
> type cast change should go via any trivial tree. It's easy to mess 
> it up. Please submit them to the maintainer trees
Ok. I'll try and find appropriate CCs. I'm going out shortly so it might
take me a while.

Thanks,

Jack
