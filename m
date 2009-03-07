Return-Path: <linux-kernel-owner+w=401wt.eu-S1752722AbZCGXNm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722AbZCGXNm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 18:13:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751257AbZCGXNd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 18:13:33 -0500
Received: from mx03.syneticon.net ([78.111.66.105]:35341 "EHLO
	mx03.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046AbZCGXNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 18:13:32 -0500
Message-ID: <49B2FF8B.4000803@wpkg.org>
Date: Sun, 08 Mar 2009 00:13:15 +0100
From: Tomasz Chmielewski <mangoo@wpkg.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081231)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: LKML <linux-kernel@vger.kernel.org>, dri-devel@lists.sourceforge.net,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: Initialized radeon -> Oops: 0000 [#1] SMP
References: <49B1754C.50109@wpkg.org> <200903072216.33271.rjw@sisk.pl>
In-Reply-To: <200903072216.33271.rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki schrieb:
> On Friday 06 March 2009, Tomasz Chmielewski wrote:
>> Don't really know where one should send Oops... Is there a better place than linux-kernel?
> 
> dri-devel@lists.sourceforge.net for one example (CCed).
> 
> Is this a regression and if so, then what's the last good kernel?

I'm not sure if it's a regression or not.
I've never seen that before.

On the other hand, I've never seen that again with 2.6.29-rc7 as well, 
so it could be a bug which hides well somewhere all the time...


-- 
Tomasz Chmielewski
http://wpkg.org
