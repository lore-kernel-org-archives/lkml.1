Return-Path: <linux-kernel-owner+w=401wt.eu-S1753413Ab0ADOQ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413Ab0ADOQ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 09:16:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753094Ab0ADOQ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 09:16:26 -0500
Received: from [150.254.222.82] ([150.254.222.82]:46642 "EHLO mail.pceuip.pl"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752524Ab0ADOQZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 09:16:25 -0500
X-Greylist: delayed 1944 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 Jan 2010 09:16:24 EST
X-Nat-Received: from [192.168.241.178]:37970 [ident-empty]
	by I DS proxy with TPROXY id 1262612625.24748
	abuse-to abuse(at)dsv.agh.edu.pl
Message-ID: <4B41F091.5000105@freesco.pl>
Date: Mon, 04 Jan 2010 14:43:45 +0100
From: Maciej Sitarz <macieks@freesco.pl>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; pl-PL; rv:1.9.1.5) Gecko/20091215 Shredder/3.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #14748] e1000e NIC not working after reboot
References: <oBElxfTZdhL.A.bx.-vhOLB@chimera> <srmJ8vMxKPH.A.C8C._whOLB@chimera>
In-Reply-To: <srmJ8vMxKPH.A.C8C._whOLB@chimera>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29.12.2009 16:28, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.31 and 2.6.32.
>
> The following bug entry is on the current list of known regressions
> introduced between 2.6.31 and 2.6.32.  Please verify if it still should
> be listed and let me know (either way).

I confirm. The problem still exists.

-- 
Maciek Sitarz
