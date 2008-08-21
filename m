Return-Path: <linux-kernel-owner+w=401wt.eu-S1755247AbYHUQDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755247AbYHUQDR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 12:03:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751837AbYHUQDB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 12:03:01 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:27661 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194AbYHUQDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 12:03:00 -0400
X-Spam-Flag: NO
X-Spam-Score: -9.389
Message-ID: <48AD91B0.2090100@tremplin-utc.net>
Date: Thu, 21 Aug 2008 18:02:56 +0200
From: Eric Piel <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.16) Gecko/20080808 Mandriva/2.0.0.16-2mdv2009.0 (2009.0) Thunderbird/2.0.0.16 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: wickey@gmx.at
Cc: linux-kernel@vger.kernel.org, corentincj@iksaif.net
Subject: Re: Unsupportet Asus Laptop /proc/acpi/dsdt 2.6.26
References: <20080810144723.90840@gmx.net>
In-Reply-To: <20080810144723.90840@gmx.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

wickey@gmx.at schreef:
> Hi!
> 
> dmesg:
> [   10.084802] Asus Laptop ACPI Extras version 0.30
> [   10.088918]   unsupported model X55SV, trying default values
> [   10.088918]   send /proc/acpi/dsdt to the developers
> 
> My Laptop is a Asus X55SV-AP166C running with Debian testing with Kernel 2.6.26-1-686 from the Debian unstable repository.
> 
> OK, there is a 
> cat /proc/acpi/dsdt > dsdt
> in the attachment
> 
> I hope it helps you to support this.
> If you need somthing else, please send a mail to me.
Hello,
I think you need to send it to the developers of the ASUS ACPI driver 
(CC'd), and/or attach the DSDT to a bug report in the sourceforge 
website: http://sourceforge.net/projects/acpi4asus .

See you,
Eric

