Return-Path: <linux-kernel-owner+w=401wt.eu-S1754169AbYAOGRq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169AbYAOGRq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 01:17:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751856AbYAOGRf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 01:17:35 -0500
Received: from hpsmtp-eml12.kpnxchange.com ([213.75.38.112]:11685 "EHLO
	hpsmtp-eml12.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751700AbYAOGRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 01:17:35 -0500
From: Frans Pop <elendil@planet.nl>
To: David Miller <davem@davemloft.net>
Subject: Re: [REGRESSION] 2.6.24-rc7: e1000: Detected Tx Unit Hang
Date: Tue, 15 Jan 2008 07:17:30 +0100
User-Agent: KMail/1.9.7
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200801150625.10823.elendil@planet.nl> <20080114.215317.38045859.davem@davemloft.net>
In-Reply-To: <20080114.215317.38045859.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801150717.31872.elendil@planet.nl>
X-OriginalArrivalTime: 15 Jan 2008 06:17:33.0167 (UTC) FILETIME=[509637F0:01C8573E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wow. That's fast! :-)

On Tuesday 15 January 2008, David Miller wrote:
> From: Frans Pop <elendil@planet.nl>
>
> > kernel: e1000: eth0: e1000_clean_tx_irq: Detected Tx Unit Hang
>
> Does this make the problem go away?

I'm compiling a kernel with the patch now. Will let you know the result.
May take a while as I don't know how to trigger the bug, so I'll just have 
to let it run for some time.
