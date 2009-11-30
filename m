Return-Path: <linux-kernel-owner+w=401wt.eu-S1753167AbZK3TTk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753167AbZK3TTk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 14:19:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752934AbZK3TTk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 14:19:40 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57725 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015AbZK3TTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 14:19:39 -0500
Message-ID: <4B141A8E.1090104@zytor.com>
Date: Mon, 30 Nov 2009 11:18:38 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: "Brown, Len" <len.brown@intel.com>
CC: helight <helight@126.com>, linux-kernel@vger.kernel.org, x86@kernel.org,
       Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Subject: [PATCH 2/2] fix a Section mismatch in arch/x86/pci/mmconfig-shared.c
 and include/linux/sfi_acpi.h
References: <4B13A094.2080504@126.com>
In-Reply-To: <4B13A094.2080504@126.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Len,

Do you want to take this one or should I?

	-hpa


On 11/30/2009 02:38 AM, helight wrote:
> acpi_sfi_table_parse() should be __init. tested on x86 system!
