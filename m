Return-Path: <linux-kernel-owner+w=401wt.eu-S1751737AbZCGX0K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751737AbZCGX0K (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 18:26:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751715AbZCGXZ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 18:25:57 -0500
Received: from mx03.syneticon.net ([78.111.66.105]:53110 "EHLO
	mx03.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827AbZCGXZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 18:25:56 -0500
Message-ID: <49B3027D.60400@wpkg.org>
Date: Sun, 08 Mar 2009 00:25:49 +0100
From: Tomasz Chmielewski <mangoo@wpkg.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081231)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Initialized radeon -> Oops: 0000 [#1] SMP
References: <49B1754C.50109@wpkg.org> <20090307152220.693ab8e8@infradead.org>
In-Reply-To: <20090307152220.693ab8e8@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven schrieb:
> On Fri, 06 Mar 2009 20:11:08 +0100
> Tomasz Chmielewski <mangoo@wpkg.org> wrote:
> 
>> Don't really know where one should send Oops... Is there a better
>> place than linux-kernel?
>>
>>
>> First time I see such an oops on this multiseat system. Everything
>> still works fine though.
>>
> 
> Hi,
> 
> if you run the oops through "markup_oops.pl" (and assuming you have
> CONFIG_DEBUG_INFO set) the oops gets part transformed into a sourcecode
> dump of where the oops is happening..... that sometimes helps in
> nailing it down.

Hmmm, no luck here, or...?

# zgrep CONFIG_DEBUG_INFO /proc/config.gz
# CONFIG_DEBUG_INFO is not set


-- 
Tomasz Chmielewski
http://wpkg.org
