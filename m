Return-Path: <linux-kernel-owner+w=401wt.eu-S1760942AbZEOJxA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760942AbZEOJxA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 05:53:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756236AbZEOJwv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 05:52:51 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:28072 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756168AbZEOJwu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 05:52:50 -0400
Message-Id: <4A0D57920200007800001150@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Fri, 15 May 2009 10:52:50 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, "Tejun Heo" <TeHeo@novell.com>,
       <hpa@zytor.com>
Cc: <andi@firstfloor.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PATCH 2.6.30-rc5] x86,percpu: fix pageattr handling
	 withremap allocator, take#2
References: <1242361739-21186-1-git-send-email-tj@kernel.org>
 <4A0D37A5.2070001@novell.com>
In-Reply-To: <4A0D37A5.2070001@novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Tejun Heo <teheo@novell.com> 15.05.09 11:36 >>>
>Tejun Heo wrote:
>> Hello,
>> 
>> Upon ack, please pull from the following git tree.
>> 
>>   git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git x86-percpu-pageattr
>
>Patches 0002 and 0003 updated per Jan's comments.  New git commit ID
>is 229f8495873f9f8928c9c99f790f2e0f4b6b0804.

With this the whole series is

Reviewed-by: Jan Beulich <jbeulich@novell.com>

