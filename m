Return-Path: <linux-kernel-owner+w=401wt.eu-S1755940AbZCDN6p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940AbZCDN6p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 08:58:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751227AbZCDN6g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 08:58:36 -0500
Received: from hera.kernel.org ([140.211.167.34]:55622 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751021AbZCDN6f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 08:58:35 -0500
Message-ID: <49AE88F9.8060100@kernel.org>
Date: Wed, 04 Mar 2009 22:58:17 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: x86-tip: cpufreq breakage -	bisection	fingers	89c9215165ca609096e845926d9a18f1306176a4
References: <1236085632.5958.8.camel@marge.simson.net>	 <20090303143106.GA12248@elte.hu> <1236098338.5926.0.camel@marge.simson.net>	 <49ADE077.1060606@kernel.org> <1236138205.6119.12.camel@marge.simson.net>	 <1236147277.6049.3.camel@marge.simson.net> <49AE2028.8040402@kernel.org>	 <49AE4C26.4040104@kernel.org>  <49AE4D40.3050705@kernel.org> <1236163460.6101.7.camel@marge.simson.net>
In-Reply-To: <1236163460.6101.7.camel@marge.simson.net>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 04 Mar 2009 13:58:21 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Galbraith wrote:
> On Wed, 2009-03-04 at 18:43 +0900, Tejun Heo wrote:
>> Tejun Heo wrote:
>>> I've used the config file you attached and the commit ID I used is
>>> d0c4f570276cb4d2dc4215b90eb7cb6e2bdd4a15.
> 
> My tip tree is at v2.6.29-rc6-2441-g4239438.

Eh... how do I map that to git commit?

Thanks.

-- 
tejun
