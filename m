Return-Path: <linux-kernel-owner+w=401wt.eu-S1754135AbZHLHoA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135AbZHLHoA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 03:44:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753667AbZHLHoA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 03:44:00 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52815 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751799AbZHLHn7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 03:43:59 -0400
Message-ID: <4A8272B2.3030309@redhat.com>
Date: Wed, 12 Aug 2009 10:43:46 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: Pierre Ossman <drzeus-list@drzeus.cx>
CC: Rusty Russell <rusty@rustcorp.com.au>, Minchan Kim <minchan.kim@gmail.com>,
       kvm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org, Wu Fengguang <fengguang.wu@intel.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>
Subject: Re: Page allocation failures in guest
References: <20090713115158.0a4892b0@mjolnir.ossman.eu>	<20090811083233.3b2be444@mjolnir.ossman.eu>	<4A811545.5090209@redhat.com>	<200908121249.51973.rusty@rustcorp.com.au> <20090812081934.33e8280f@mjolnir.ossman.eu>
In-Reply-To: <20090812081934.33e8280f@mjolnir.ossman.eu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12/2009 09:19 AM, Pierre Ossman wrote:
> Will it still trigger the OOM killer with this patch, or will things
> behave slightly more gracefully?
>    

I don't think you mentioned the OOM killer in your original report?  Did 
it trigger?


-- 
error compiling committee.c: too many arguments to function

