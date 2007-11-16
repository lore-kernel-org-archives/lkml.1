Return-Path: <linux-kernel-owner+w=401wt.eu-S935591AbXKPXeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935591AbXKPXeS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 18:34:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762796AbXKPXeH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 18:34:07 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56128 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752368AbXKPXeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 18:34:03 -0500
Message-ID: <473E28E0.8050307@zytor.com>
Date: Fri, 16 Nov 2007 15:33:52 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Andreas Herrmann <aherrman@arcor.de>, linux-kbuild@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Kconfig: ARCH=x86 causes wrong utsname.machine
References: <20071116111446.GA16968@devil> <20071116123747.GA12086@devil> <473DB52F.2040703@zytor.com> <20071116221535.GA1810@uranus.ravnborg.org> <473E209A.7080806@zytor.com>
In-Reply-To: <473E209A.7080806@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
>>
>> Should we report a "make ARCH=x86" as uname -m == x86??
>>
> 
> That would break 5 years of a stable ABI.  I don't think that is even 
> remotely feasible.
> 

Make that 5 years for x86-64, 16 years for i386...

	-hpa
