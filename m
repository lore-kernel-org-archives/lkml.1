Return-Path: <linux-kernel-owner+w=401wt.eu-S1760759AbXHACdK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760759AbXHACdK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 22:33:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753779AbXHACc7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 22:32:59 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49868 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753432AbXHACc6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 22:32:58 -0400
Message-ID: <46AFF092.6050802@kernel.sg>
Date: Wed, 01 Aug 2007 10:31:46 +0800
From: Eugene Teo <eugeneteo@kernel.sg>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-kernel@vger.kernel.org,
       "Kawai, Hidehiro" <hidehiro.kawai.ez@hitachi.com>,
       Neil Horman <nhorman@tuxdriver.com>, Bryan Wu <bryan.wu@analog.com>
Subject: Re: [PATCH 1/3] coredump: cleanup documentation for suid_dumpable
References: <20070731070238.GA2412@kernel.sg>	<20070731070340.GB2412@kernel.sg> <20070731091337.5f3cb923@the-village.bc.nu>
In-Reply-To: <20070731091337.5f3cb923@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

Alan Cox wrote:
> On Tue, 31 Jul 2007 15:03:40 +0800
> Eugene Teo <eugeneteo@kernel.sg> wrote:
> 
>> This patch removes documentation that is related to suidsafe core dump
>> mode.
>>
>> Signed-off-by: Eugene Teo <eugeneteo@kernel.sg>
> 
> NAK - this feature is actively used and can be set by the sysctl
> interface. The PRCTL fixup was just a bug being fixed. The sysctl
> interface is still relevant.

Thank you for correcting me. Appreciated. I am not aware that it is still
being actively used. May I know who or which program is using this feature?

Thanks,
Eugene
