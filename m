Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652Ab0CFXUc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Mar 2010 18:20:32 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58316 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751987Ab0CFXUb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Mar 2010 18:20:31 -0500
Message-ID: <4B92E296.1040804@zytor.com>
Date: Sat, 06 Mar 2010 15:17:42 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Shaohua Li <shaohua.li@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "colin.king@canonical.com" <colin.king@canonical.com>
Subject: Re: [PATCH] i386: do a global tlb flush in S4 resume
References: <1267665799-670-1-git-send-email-shaohua.li@intel.com> <20100305005932.GA22675@sli10-desk.sh.intel.com> <201003052155.26292.rjw@sisk.pl> <201003062254.46584.rjw@sisk.pl>
In-Reply-To: <201003062254.46584.rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/2010 01:54 PM, Rafael J. Wysocki wrote:
> 
> Peter, are you going to take it or should I handle it?
> 

I'll take it after -rc1.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

