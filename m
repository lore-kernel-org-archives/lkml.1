Return-Path: <linux-kernel-owner+w=401wt.eu-S1754705AbYHMAV6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705AbYHMAV6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 20:21:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753268AbYHMAVs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 20:21:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36525 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264AbYHMAVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 20:21:47 -0400
Message-ID: <48A228FC.5030303@zytor.com>
Date: Tue, 12 Aug 2008 17:21:16 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Joerg Roedel <joro@8bytes.org>, mingo@redhat.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: Setup code crashes my old 486 box
References: <20080812224703.GV31439@8bytes.org>	<48A2155B.1020904@zytor.com> <20080812235535.18f7519c@lxorguk.ukuu.org.uk>
In-Reply-To: <20080812235535.18f7519c@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> Right in concept, but I dislike the implementation (duplication of the 
>> CPU detect code we already have).  Could you try this patch and see if 
>> it works for you?
> 
> I was under the impression that spudstop came in with the Pentium II so
> presumably < 6 would be even safer ?

I think you're right about that.

	-hpa
