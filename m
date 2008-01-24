Return-Path: <linux-kernel-owner+w=401wt.eu-S1760765AbYAXRIl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760765AbYAXRIl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 12:08:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760681AbYAXRIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 12:08:10 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:32878 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758405AbYAXRIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 12:08:09 -0500
Message-ID: <4798C5F5.9080900@davidnewall.com>
Date: Fri, 25 Jan 2008 03:38:05 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH for mm] Remove iBCS support
References: <20080119045918.GA12215@basil.nowhere.org>	<4792B191.2060801@davidnewall.com>	<20080120031153.GB6275@one.firstfloor.org>	<4792D221.1010704@davidnewall.com>	<20080120051822.GB19784@one.firstfloor.org>	<4792DD22.4070902@davidnewall.com>	<20080120055544.GB19861@one.firstfloor.org>	<4792E8E2.1090307@davidnewall.com>	<20080120072922.GA21047@one.firstfloor.org>	<4793F775.6090403@davidnewall.com>	<20080122111205.GA25090@elte.hu>	<4796081A.7060505@davidnewall.com> <20080122165015.5aca62ac@lxorguk.ukuu.org.uk>
In-Reply-To: <20080122165015.5aca62ac@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>  
>   
>> You're being silly.  Either that or you're not reading what I write. 
>> You know perfectly well iBCS2 compatibility doesn't work (anymore.)  The
>> question, in my mind, is will it ever be made to work again?  I think
>> the answer should be yes.
>>     
>
> We await your patches. If you think it should be done then rework the
> code, test it and figure how to merge it nicely.

Apparently a patch already exists.
