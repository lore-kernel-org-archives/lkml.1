Return-Path: <linux-kernel-owner+w=401wt.eu-S1753772AbZCKO2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753772AbZCKO2T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 10:28:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751927AbZCKO2E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 10:28:04 -0400
Received: from mail.mnementh.co.uk ([173.45.232.4]:57830 "EHLO mnementh.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751194AbZCKO2D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 10:28:03 -0400
X-Greylist: delayed 354 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Mar 2009 10:28:03 EDT
Message-ID: <49B7C907.6030209@mnementh.co.uk>
Date: Wed, 11 Mar 2009 14:21:59 +0000
From: Ian Molton <ian@mnementh.co.uk>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Magnus Damm <magnus.damm@gmail.com>
CC: linux-kernel@vger.kernel.org, drzeus-wbsd@drzeus.cx,
       akpm@linux-foundation.org
Subject: Re: [PATCH 05/05] tmio_mmc: Support multiple interrupts
References: <20090311125845.1563.31960.sendpatchset@rx1.opensource.se> <20090311125928.1563.26784.sendpatchset@rx1.opensource.se>
In-Reply-To: <20090311125928.1563.26784.sendpatchset@rx1.opensource.se>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Magnus Damm wrote:
> From:  Magnus Damm <damm@opensource.se>
> 
> Add support for tmio_mmc hardware configurations with
> multiple interrupts. With this patch applied all interrupts
> passed as platform data will be used by the driver.

What is this patch intended to support?

