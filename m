Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756389Ab0BGLnI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 06:43:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1237 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756224Ab0BGLnE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 06:43:04 -0500
Message-ID: <4B6EA745.5020209@redhat.com>
Date: Sun, 07 Feb 2010 13:43:01 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: linux-kernel@vger.kernel.org, Xiantao Zhang <xiantao.zhang@intel.com>,
       Marcelo Tosatti <mtosatti@redhat.com>, Tony Luck <tony.luck@intel.com>,
       Fenghua Yu <fenghua.yu@intel.com>, kvm-ia64@vger.kernel.org,
       kvm@vger.kernel.org, linux-ia64@vger.kernel.org
Subject: Re: [PATCH 01/10] arch/ia64: Fix continuation line formats
References: <cover.1265095093.git.joe@perches.com> <f3f06427c791446de7aaba9df811f29db12dd831.1265095094.git.joe@perches.com>
In-Reply-To: <f3f06427c791446de7aaba9df811f29db12dd831.1265095094.git.joe@perches.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/02/2010 09:22 AM, Joe Perches wrote:
> String constants that are continued on subsequent lines with \
> are not good.
>    

Applied, thanks.

-- 
error compiling committee.c: too many arguments to function

