Return-Path: <linux-kernel-owner+w=401wt.eu-S1161115AbXDVXoa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161115AbXDVXoa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 19:44:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161139AbXDVXoa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 19:44:30 -0400
Received: from smtp161.iad.emailsrvr.com ([207.97.245.161]:41282 "EHLO
	smtp161.iad.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161115AbXDVXo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 19:44:27 -0400
Message-ID: <462BF33C.7010708@gentoo.org>
Date: Sun, 22 Apr 2007 19:43:56 -0400
From: Daniel Drake <dsd@gentoo.org>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: caglar@pardus.org.tr
CC: kune@deine-taler.d, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add missing  USRobotics Wireless Adapter (Model 5423)
 id  into zd1211rw
References: <200704220052.48637.caglar@pardus.org.tr>
In-Reply-To: <200704220052.48637.caglar@pardus.org.tr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

S.Çağlar Onur wrote:
> USRobotics Wireless Adapter (Model 5423) works well with current zd1211rw 
> driver also (i have tested 2.6.18, 2.6.20 and 2.6.21-rc7). I know -mm/and 
> Daniel's tree has new version (i think with more features like rate estimator 
> etc.) of this driver but maybe you should consider that one as a .21 material 
> instead of waiting full wireless-dev merge? 

This ID addition is already on the way up the chain. It will be 
supported in 2.6.22.

Thanks,
Daniel

