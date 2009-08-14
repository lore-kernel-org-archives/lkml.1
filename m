Return-Path: <linux-kernel-owner+w=401wt.eu-S1756831AbZHNOGp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756831AbZHNOGp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 10:06:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755671AbZHNOGp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 10:06:45 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:46715 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753959AbZHNOGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 10:06:44 -0400
Message-ID: <4A856F6C.5080802@simtec.co.uk>
Date: Fri, 14 Aug 2009 15:06:36 +0100
From: Ben Dooks <ben@simtec.co.uk>
Organization: Simtec Electronics, UK
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: spi-devel-general@lists.sourceforge.net, dbrownell@users.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 0/7] SPI fixes for documentation and spi_s3c24xx driver
References: <20090813100602.545180197@fluff.org> <20090813142455.2489ce67.akpm@linux-foundation.org>
In-Reply-To: <20090813142455.2489ce67.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Thu, 13 Aug 2009 11:06:02 +0100
> Ben Dooks <ben@simtec.co.uk> wrote:
> 
>> Fix spello in the SPI documentation and fix the behaviour and bugs
>> in the spi_s3c24xx driver. 
>>
> 
> Do you think that any of these are needed in 2.6.31, or earlier?

The following would be useful to get in:
	spi_s3c24xx-fix-clock-rate-calculation.patch
	spi_s3c24xx-fix-transfer-setup-code.patch

The rest can wait.

-- 
Ben Dooks, Software Engineer, Simtec Electronics

http://www.simtec.co.uk/
