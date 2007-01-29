Return-Path: <linux-kernel-owner+w=401wt.eu-S1752500AbXA2Qky@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752500AbXA2Qky (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 11:40:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752511AbXA2Qky
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 11:40:54 -0500
Received: from zcars04e.nortel.com ([47.129.242.56]:37033 "EHLO
	zcars04e.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752500AbXA2Qkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 11:40:53 -0500
Message-ID: <45BE238A.9060103@nortel.com>
Date: Mon, 29 Jan 2007 10:40:42 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
CC: linux-kernel@vger.kernel.org, libc-hacker@sources.redhat.com,
       libc-alpha@sources.redhat.com
Subject: Re: [ANN] Userspace M-on-N threading model implementation. Alpha
 release.
References: <20070129145227.GA10524@2ka.mipt.ru>
In-Reply-To: <20070129145227.GA10524@2ka.mipt.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Jan 2007 16:40:46.0539 (UTC) FILETIME=[39C7B9B0:01C743C4]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Evgeniy Polyakov wrote:
> Hello.
> 
> I'm pleased to announce initial userspace M-on-N threading model
> implementation (for hackers) called NTL. 

If you haven't already, I suggest you look into the story of NGPT and 
also read the NPTL white paper 
(http://people.redhat.com/drepper/nptl-design.pdf) especially section 
5.1 describing why they went with a 1:1 model.

Chris
