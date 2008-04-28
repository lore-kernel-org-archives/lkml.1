Return-Path: <linux-kernel-owner+w=401wt.eu-S938033AbYD1VKB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938033AbYD1VKB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 17:10:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965542AbYD1VJU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 17:09:20 -0400
Received: from gw.goop.org ([64.81.55.164]:48582 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965773AbYD1VJT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 17:09:19 -0400
Message-ID: <48163CF4.6050501@goop.org>
Date: Mon, 28 Apr 2008 14:09:08 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080418)
MIME-Version: 1.0
To: Chris Wright <chrisw@sous-sol.org>
CC: Adrian Bunk <bunk@kernel.org>, Jeremy Fitzhardinge <jeremy@xensource.com>,
       xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Subject: Re: drivers/xen/grant-table.c:gnttab_suspend() is unused
References: <20080428153900.GI2813@cs181133002.pp.htv.fi> <20080428174857.GG18358@sequoia.sous-sol.org>
In-Reply-To: <20080428174857.GG18358@sequoia.sous-sol.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Wright wrote:
> * Adrian Bunk (bunk@kernel.org) wrote:
>   
>> drivers/xen/grant-table.c:gnttab_suspend() is unused, and I have the gut 
>> feeling it should have been used.
>>     
>
> Right, it should get used when suspending a guest supported.
>   

I'm working on that at the moment, so we may as well keep it for now.

    J
