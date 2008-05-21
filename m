Return-Path: <linux-kernel-owner+w=401wt.eu-S934808AbYEUOAO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934808AbYEUOAO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 10:00:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763988AbYEUN77
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 09:59:59 -0400
Received: from mail.netone.net.tr ([193.192.98.182]:26089 "EHLO
	mail.netone.net.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763832AbYEUN76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 09:59:58 -0400
Message-ID: <48342ADC.3030509@netone.net.tr>
Date: Wed, 21 May 2008 16:59:56 +0300
From: Tarkan Erimer <tarkan@netone.net.tr>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: Re: Suggestion About Kernel Releases
References: <48341ED5.7060508@netone.net.tr> <20080521063855.0bdb441c@infradead.org>
In-Reply-To: <20080521063855.0bdb441c@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 May 2008 13:57:31.0922 (UTC) FILETIME=[9D304720:01C8BB4A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> what would you want to accomplish with your idea?
>   

To make kernel releases more stable/tested via "testX" series, as 
recently discussed by David Miller's "Slow DOWN, please!!!" thread. 
These "testX" releases will give more opportunity and time to test more 
these new releases. Also, with the aim of the "testX" series, the new 
kernel release schedules/merge windows will be not slow down. Even, 
Linus can releases new kernels more quickly. Because, testing purpose 
should be handled by someone else like Chris did for 2.6.x.y.
