Return-Path: <linux-kernel-owner+w=401wt.eu-S1759101AbZEKWGt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759101AbZEKWGt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 18:06:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753030AbZEKWGj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 18:06:39 -0400
Received: from gw.goop.org ([64.81.55.164]:43095 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757115AbZEKWGj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 18:06:39 -0400
Message-ID: <4A08A16E.4040003@goop.org>
Date: Mon, 11 May 2009 15:06:38 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 02/18] xen: hook io_apic read/write operations
References: <1241730883-4917-1-git-send-email-jeremy@goop.org> <1241730883-4917-3-git-send-email-jeremy@goop.org> <20090509084201.GF3656@elte.hu> <20090509084324.GA5158@elte.hu> <4A05A408.3020006@goop.org> <20090511111904.GK4648@elte.hu> <4A086D8C.3060404@goop.org> <20090511214338.GD21232@elte.hu>
In-Reply-To: <20090511214338.GD21232@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>   
>> But I do think hooking the io-apic operations makes more sense 
>> than any other solution because we explicitly want all the other 
>> code above it.
>>     
>
> That sounds OK-ish at first sight.
>   

OK.  Shall I re-spin with io_apic_ops?

    J
