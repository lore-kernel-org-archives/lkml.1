Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751465Ab0CEFBu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 00:01:50 -0500
Received: from hera.kernel.org ([140.211.167.34]:54213 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750841Ab0CEFBt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 00:01:49 -0500
Message-ID: <4B909016.1070605@kernel.org>
Date: Fri, 05 Mar 2010 14:01:10 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: werner@guyane.dyn-o-saur.com
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: 2.6.33 problems
References: <1267587210.10602@guyane.dyn-o-saur.com> <4B8DE479.1030308@kernel.org>
In-Reply-To: <4B8DE479.1030308@kernel.org>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 05 Mar 2010 05:01:14 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/03/2010 01:24 PM, Tejun Heo wrote:
> Here, the unit size is 2M and the chunk size 4M for the two possible
> cpus.  This isn't excessive at all and i386 shouldn't have much
> problem accomodating it.  Have you tried percpu_alloc=page?

Ping?

-- 
tejun
