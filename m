Return-Path: <linux-kernel-owner+w=401wt.eu-S1764038AbXKNVXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764038AbXKNVXU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 16:23:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761738AbXKNVW7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 16:22:59 -0500
Received: from mho-02-bos.mailhop.org ([63.208.196.179]:61635 "EHLO
	mho-02-bos.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760515AbXKNVW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 16:22:57 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 209.94.135.27
X-Report-Abuse-To: abuse@dyndns.com (see http://www.mailhop.org/outbound/abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18IIKuqt65R9Z/qO6U1z0sh
Message-ID: <473B6725.5010503@reed.com>
Date: Wed, 14 Nov 2007 16:22:45 -0500
From: "David P. Reed" <dpreed@reed.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.5) Gecko/20070727 Fedora/2.0.0.5-2.fc7 Thunderbird/2.0.0.5 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Matt Mackall <mpm@selenic.com>
CC: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Allessandro Zummo <a.zummo@towertech.it>
Subject: Re: [PATCH] x86: fix locking and sync bugs in x86_64 RTC code in
 time_64.c
References: <469578CD.3080609@reed.com> <1184216528.12353.203.camel@chaos> <1184218962.12353.209.camel@chaos> <46964352.7040301@reed.com> <1184253339.12353.223.camel@chaos> <469697C6.50903@reed.com> <1184274754.12353.254.camel@chaos> <47388586.7010509@reed.com> <alpine.LFD.0.9999.0711140826080.3265@localhost.localdomain> <473AF3BE.1010006@reed.com> <20071114182647.GA17536@waste.org>
In-Reply-To: <20071114182647.GA17536@waste.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Cool. More reason to separate this into two.

Matt Mackall wrote:
> On Wed, Nov 14, 2007 at 08:10:22AM -0500, David P. Reed wrote:
>   
>> Will make two patches and resend.
>>     
>
> I've already got a set of patches brewing to fix the UIP problem across all
> the affected arches (11+).
>
>   
