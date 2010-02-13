Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757736Ab0BMSkl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 13:40:41 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:59218 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752195Ab0BMSki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 13:40:38 -0500
Message-ID: <4B76F225.1090209@forouher.de>
Date: Sat, 13 Feb 2010 19:40:37 +0100
From: Dariush Forouher <dariush@forouher.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20100109 Icedove/3.0
MIME-Version: 1.0
To: Robert Hancock <hancockrwd@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-acpi <linux-acpi@vger.kernel.org>
Subject: Re: ACPI/ata regression with hotplugging the dvd drive
References: <4B76D3E7.6000904@forouher.de> <4B76EE70.1060605@gmail.com>
In-Reply-To: <4B76EE70.1060605@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1/91lDNGHXf2GqwCRb/mDtzRZg/9Y7mTgWjs0r
 zzXaz6QS8tTZmukk3DedbN3ozdm0+MW8Alpwydd7LaW0oIX1P/
 QXAf+jhmbTUvYclOAVZZw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13.02.2010 19:24, Robert Hancock wrote:

> This lockdep error in dmesg looks suspicious. Does this match the point 
> where the DVD drive was inserted?

Yes, it does. Looking back through the logs, it appears sporadically since at
least 2.6.32, always when inserting the drive.

regards
Dariush
