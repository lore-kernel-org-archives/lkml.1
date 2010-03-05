Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824Ab0CEGXo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 01:23:44 -0500
Received: from cpsmtpm-eml104.kpnxchange.com ([195.121.3.8]:62499 "EHLO
	CPSMTPM-EML104.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753633Ab0CEGXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 01:23:42 -0500
Message-ID: <4B90A366.9080201@gmail.com>
Date: Fri, 05 Mar 2010 07:23:34 +0100
From: Gertjan van Wingerde <gwingerde@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100125 Lightning/1.0b2pre Shredder/3.0.1
MIME-Version: 1.0
Newsgroups: gmane.comp.file-systems.ext4,gmane.linux.kernel
To: Justin Piszcz <jpiszcz@lucidpixels.com>
CC: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: dump/restore not supported for ext4
References: <alpine.DEB.2.00.1003041704230.17723@p34.internal.lan>
In-Reply-To: <alpine.DEB.2.00.1003041704230.17723@p34.internal.lan>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Mar 2010 06:23:35.0828 (UTC) FILETIME=[62F4E540:01CABC2C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04/10 23:05, Justin Piszcz wrote:
> Hi,
> 
> I should have researched it more:
> 
> http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=511651
> https://lists.ubuntu.com/archives/universe-bugs/2009-June/098729.html
> 
> Looks like it's broken, I agree with the reporters, dump should abort if
> it is dealing with an ext4 filesystem, since you cannot restore data
> from an ext4 dump.
> 
> Justin.
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Hi Justin,

It seems you are using an outdated version of dump.
The latest version of dump, 0.4b42 does contain support for ext4.
I've been using it for the last 8 months for my backups of ext4 without
any problems and restoring is not issue at all with this version.

---
Gertjan.
