Return-Path: <linux-kernel-owner+w=401wt.eu-S1754532AbYCKRe4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532AbYCKRe4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 13:34:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752569AbYCKRer
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 13:34:47 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:51401 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752497AbYCKReq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 13:34:46 -0400
Message-ID: <47D6C2AC.8010907@suse.de>
Date: Tue, 11 Mar 2008 20:34:36 +0300
From: Alexey Starikovskiy <astarikovskiy@suse.de>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, Andi Kleen <ak@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: mpparse_{32,64}.c merge questions
References: <47CDB9D7.9030107@suse.de> <47CDBFD9.1050703@suse.de> <20080304213552.GD8944@elte.hu> <200803111328.43314.lenb@kernel.org>
In-Reply-To: <200803111328.43314.lenb@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Len Brown wrote:
> I agree with Ingo on the "keep it simple" merge steps..
> 
> I can't resist mentioning, however, what I'd like to see long term.
> 
> I'd like to see mpparse.o depend on CONFIG_MPS=y
> I'd like to be able to build CONFIG_ACPI=y and CONFIG_MPS=n
That was original goal set by Andy Kleen.

Thanks,
Alex.
