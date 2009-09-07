Return-Path: <linux-kernel-owner+w=401wt.eu-S1752798AbZIGKMj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798AbZIGKMj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 06:12:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752628AbZIGKMj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 06:12:39 -0400
Received: from lo.gmane.org ([80.91.229.12]:43969 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752523AbZIGKMi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 06:12:38 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Nikos Chantziaras <realnc@arcor.de>
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
Date: Mon, 07 Sep 2009 13:12:15 +0300
Organization: Lucas Barks
Message-ID: <h82ma1$h9f$1@ger.gmane.org>
References: <20090906205952.GA6516@elte.hu> <20090907094953.GP18599@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: athedsl-374927.home.otenet.gr
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090826 Thunderbird/3.0b3
In-Reply-To: <20090907094953.GP18599@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/07/2009 12:49 PM, Jens Axboe wrote:
> [...]
> And I have to apologize for using a large system to test this on, I
> realize it's out of the scope of BFS, but it's just easier to fire one
> of these beasts up than it is to sacrifice my notebook or desktop
> machine...

How does a kernel rebuild constitute "sacrifice"?


> So it's a 64 thread box. CFS -jX runtime is the baseline at
> 100, lower number means faster and vice versa. The latency numbers are
> in msecs.
>
>
> Scheduler       Runtime         Max lat     Avg lat     Std dev
> ----------------------------------------------------------------
> CFS             100             951         462         267
> CFS-x2          100             983         484         308
> BFS
> BFS-x2
>
> And unfortunately this is where it ends for now, since BFS doesn't boot
> on the two boxes I tried.

Then who post this in the first place?

