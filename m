Return-Path: <linux-kernel-owner+w=401wt.eu-S1767782AbXDFPlF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767782AbXDFPlF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 11:41:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767780AbXDFPlE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 11:41:04 -0400
Received: from terminus.zytor.com ([192.83.249.54]:43346 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767784AbXDFPlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 11:41:01 -0400
Message-ID: <461669CD.3080900@zytor.com>
Date: Fri, 06 Apr 2007 08:39:57 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: "Antonino A. Daplas" <adaplas@gmail.com>,
       Paul LeoNerd Evans <leonerd@leonerd.org.uk>,
       Andrew Morton <akpm@osdl.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: [PATCH] vt: Expose system-wide UTF-8 default setting via sysfs
References: <4611ACCD.5000305@gmail.com> <20070403162051.GB5266@ucw.cz> <20070403163553.GO26707@cel.leo> <1175665163.4519.7.camel@daplas> <20070404080140.GC8256@elf.ucw.cz>
In-Reply-To: <20070404080140.GC8256@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> 
> You could do that... during development series. But this is
> userspace-visible API change, and those are not allowed during stable.
> 

Only if you change the default setting.

	-hpa
