Return-Path: <linux-kernel-owner+w=401wt.eu-S1753559AbYITKzt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753559AbYITKzt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 06:55:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751421AbYITKzl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 06:55:41 -0400
Received: from ptb-relay01.plus.net ([212.159.14.145]:42929 "EHLO
	ptb-relay01.plus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344AbYITKzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 06:55:40 -0400
Message-ID: <48D4D6AE.70705@yahoo.com>
Date: Sat, 20 Sep 2008 11:55:42 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
User-Agent: Thunderbird 2.0.0.16 (Macintosh/20080707)
MIME-Version: 1.0
CC: Alexey Starikovskiy <astarikovskiy@suse.de>, linux-kernel@vger.kernel.org,
       lenb@kernel.org
Subject: Re: Reading EeePC900 battery info causes stalls
References: <fa.aea4e10hJLpVS/qr4bumSa5e9C0@ifi.uio.no> <fa.uDmoMIWw4thxpZxpYeSIpVJhAOo@ifi.uio.no> <fa.RIMmQqN9ybFSKBqOk9Gxi/mOeB4@ifi.uio.no> <fa.XLGLzP+T4fm9CkeATkS1VL/Yz4Q@ifi.uio.no> <fa.z8sKLpwDO3qQ15ZJIm152YEty4I@ifi.uio.no> <fa.KyW7dWWjiSFnFxwdZZLurmVn8qA@ifi.uio.no> <48D4CC1B.7030708@yahoo.com> <48D4CFA5.7010501@suse.de> <48D4D5CA.1060104@yahoo.com>
In-Reply-To: <48D4D5CA.1060104@yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Plusnet-Relay: 4f9c1e4a1d7dc0ce5664beec8b7f1472
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sitsofe Wheeler wrote:
> Hi Alexey,
> 
> Alexey Starikovskiy wrote:
>> eeePC is known to be affected by EC GPE storm bug, and there is a 
>> patch for 2.6.27 to workaround the problem. please look at
>> http://bugzilla.kernel.org/show_bug.cgi?id=11549
>> for latest patch and bugs 10724/9998 for problem discussion.
> 
> Even with http://bugzilla.kernel.org/attachment.cgi?id=17845&action=view 
> (fast transaction) applied the stalls are still present (and seemingly 
> just as bad as before).

I should note that the patch DOES fix the slow volume hotkey repeat rate 
that I was seeing.
