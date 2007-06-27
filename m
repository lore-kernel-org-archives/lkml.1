Return-Path: <linux-kernel-owner+w=401wt.eu-S1760510AbXF0GP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760510AbXF0GP3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 02:15:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757314AbXF0GPU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 02:15:20 -0400
Received: from ihemail1.lucent.com ([135.245.0.33]:45655 "EHLO
	ihemail1.lucent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756928AbXF0GPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 02:15:18 -0400
Message-ID: <4682007F.2080504@alcatel-lucent.com>
Date: Wed, 27 Jun 2007 14:15:27 +0800
From: gshan <gshan@alcatel-lucent.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6 Linux for PowerPC supports kdb?
References: <4681D39B.2000604@alcatel-lucent.com> <20070626220520.380c1798.randy.dunlap@oracle.com>
In-Reply-To: <20070626220520.380c1798.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Jun 2007 06:15:08.0570 (UTC) FILETIME=[82F4F7A0:01C7B882]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> On Tue, 26 Jun 2007 23:03:55 -0400 Shan, Guo Wen (Gavin) wrote:
>
>   
>> Does anybody knew if 2.6 linux for PowerPC supports kdb?
>>     
>
> PowerPC isn't listed AFAICT:
> ftp://oss.sgi.com/www/projects/kdb/download/v4.4/README
>
> I.e., all that I see are i386, x86_64, and ia64.
>
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
>   
Thanks, Randy. So the kgdb is the only tool I could use to debug the 
kernel right now?
