Return-Path: <linux-kernel-owner+w=401wt.eu-S1422866AbXBHBSu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422866AbXBHBSu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 20:18:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422869AbXBHBSu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 20:18:50 -0500
Received: from mf2.realtek.com.tw ([60.248.182.6]:1175 "EHLO
	mf2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422866AbXBHBSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 20:18:49 -0500
Message-ID: <45CA7A75.1060704@realtek.com.tw>
Date: Thu, 08 Feb 2007 09:18:45 +0800
From: =?Big5?B?s1yr7bnF?= <edward_hsu@realtek.com.tw>
User-Agent: Mozilla Thunderbird 1.0.2 (Windows/20050317)
X-Accept-Language: zh-tw, en-us, en, zh
MIME-Version: 1.0
To: Francois Romieu <romieu@fr.zoreil.com>
CC: jeff@garzik.org, linux-kernel@vger.kernel.org, hiwu@realtek.com.tw
Subject: Re: [PATCH 2.6.19.2] r8169: support RTL8169SC/8110SC
References: <45C2F390.4070805@realtek.com.tw> <20070203003952.GA22823@electric-eye.fr.zoreil.com> <45C6A8EC.5090201@realtek.com.tw> <20070206003130.GA18236@electric-eye.fr.zoreil.com> <45C7EB8A.1090700@realtek.com.tw> <20070206213827.GA25119@electric-eye.fr.zoreil.com> <45C94693.5090900@realtek.com.tw> <20070207234943.GA4445@electric-eye.fr.zoreil.com>
In-Reply-To: <20070207234943.GA4445@electric-eye.fr.zoreil.com>
X-MIMETrack: Itemize by SMTP Server on msx/Realtek(Release 6.5.3|September 14, 2004) at
 2007/02/08 =?Bog5?B?pFekyCAwOToxODo0NQ==?=,
	Serialize by Router on msx/Realtek(Release 6.5.3|September 14, 2004) at
 2007/02/08 =?Bog5?B?pFekyCAwOToxODo0Ng==?=,
	Serialize complete at 2007/02/08 =?Bog5?B?pFekyCAwOToxODo0Ng==?=
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=Big5
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Francois Romieu ´£¨ì:

>³\«í¹Å <edward_hsu@realtek.com.tw> :
>  
>
>>Dear Francois:
>>
>>I think I didn't make it clear about the programming manuals for PCI-E ICs.
>>
>>Due to several legal issues, Realtek won't put the programming guide on 
>>its website. However, Realtek does offer the programming guide if the 
>>customers need it. If you want to have a copy of it, please contact 
>>Realtek FAE<ryankao@realtek.com.tw>.
>>    
>>
>
>Does it mean that the documentation is NDAed ?
>  
>
ANS:
No, you don't have to sign anything.

>On an unrelated topic, revision 8.001.00 of your 8168 driver includes
>a workaround for an rx fifo overflow issue. Is it an event which can
>happen at any time, repeteadly if some rare conditions are met or is
>it enough to whack the device once for all when the problem happens ?
>  
>
ANS:
No, it seldom happens. It does happen in a few rare conditions. When
this event happens, the nic works improperly and I do the patch to
rescue the device.

