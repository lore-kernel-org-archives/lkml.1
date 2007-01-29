Return-Path: <linux-kernel-owner+w=401wt.eu-S1751385AbXA2NqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751385AbXA2NqR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 08:46:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751399AbXA2NqR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 08:46:17 -0500
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:46667 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385AbXA2NqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 08:46:16 -0500
Message-ID: <45BDFA9B.6020403@gmail.com>
Date: Mon, 29 Jan 2007 14:46:03 +0100
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061206)
MIME-Version: 1.0
To: akpm@osdl.org
CC: ak@suse.de, jeremy@goop.org, rusty@rustcorp.com.au, zach@vmware.com,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: - romsignature-checksum-cleanup-2.patch removed from -mm tree
References: <200701102244.l0AMiWIA010198@shell0.pdx.osdl.net>
In-Reply-To: <200701102244.l0AMiWIA010198@shell0.pdx.osdl.net>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10/2007 11:44 PM, akpm@osdl.org wrote:

> The patch titled
>      romsignature/checksum cleanup
> has been removed from the -mm tree.  Its filename was
>      romsignature-checksum-cleanup-2.patch
> 
> This patch was dropped because x86_64 tree changes trashed it

I was (am) quite unsure why this was, given that the patch did not touch 
x86_64 at all and moreover continued to apply cleanly to mm...

Did you just mean you also wanted the x86_64 version of it? In the next 
two messages I'll resubmit the i386 version, and submit the x86_64 version.

i386 has been compiled and tested, x86_64 has been crosscompiled only, 
due to lack of hardware. It's completely the same as the i386 version 
though...

Rene.
