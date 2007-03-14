Return-Path: <linux-kernel-owner+w=401wt.eu-S1161121AbXCNKtv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161121AbXCNKtv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 06:49:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161115AbXCNKtv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 06:49:51 -0400
Received: from mx-b.polytechnique.fr ([129.104.30.15]:40885 "EHLO
	mx-b.polytechnique.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161095AbXCNKtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 06:49:50 -0400
Message-ID: <45F7D349.10006@crans.org>
Date: Wed, 14 Mar 2007 11:49:45 +0100
From: =?UTF-8?B?TWF0aGlldSBCw6lyYXJk?= <Mathieu.Berard@crans.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org
Subject: Re: [3/6] 2.6.21-rc2: known regressions
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org> <20070305015036.GH3441@stusta.de> <45EE9E39.3010800@garzik.org> <45F20541.9090208@crans.org> <45F53B60.8020908@gmail.com> <45F69989.70702@crans.org> <45F69C02.2020206@gmail.com> <45F71003.4030003@crans.org> <45F7910C.6060502@gmail.com>
In-Reply-To: <45F7910C.6060502@gmail.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo a écrit :
> Hello,
>
>
> Due to blacklisting, NCQ
> won't be turned on your drive in future kernels.
>
>   
Hello thanks.
I have found on Hitachi website the technical datasheets of my drive
model:
http://www.hitachigst.com/tech/techlib.nsf/techdocs/28DCCB17E0EEC5A086256F4E006E2F5B/$file/5K100_SATA_sp1.2.pdf
It seems to state that the drive does not support NCQ...

--
Mathieu

