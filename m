Return-Path: <linux-kernel-owner+w=401wt.eu-S1754367AbZFFJQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754367AbZFFJQU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 05:16:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752602AbZFFJQM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 05:16:12 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:4950 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445AbZFFJQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 05:16:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=kZzbQFY2hcMCgv/3FLgoQwG6o5EjCBT4KcirctiqjWtcXyt3lMWNvnfED7w6doVPW3
         4pu1hnawVLNIgguVl+/7Z2gCwdfQRL2e0IdkGHbTjI3XC7AT1jdGJiB0pShTX8y39bIE
         LCVjfpt8NOzrbtI+o2V25x8+5XtSFAM3CjDhM=
Message-ID: <4A2A33DA.4090401@gmail.com>
Date: Sat, 06 Jun 2009 11:16:10 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1pre) Gecko/20090528 SUSE/3.0b2-11.2 Thunderbird/3.0b3pre
MIME-Version: 1.0
To: saurabh chokshi <sdchokshi@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Fwd: Segmentation Fault with Linux Kernel 2.6.29
References: <6f5aac130906041048kc72d864y84ccd9f07737862b@mail.gmail.com> <6f5aac130906051558i4852c861q96eff9432738df69@mail.gmail.com>
In-Reply-To: <6f5aac130906051558i4852c861q96eff9432738df69@mail.gmail.com>
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/2009 12:58 AM, saurabh chokshi wrote:
> Could anyone help me out to resolve these issues?

Please append a dmesg output after some of the segfaults.
