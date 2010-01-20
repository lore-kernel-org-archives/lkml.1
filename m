Return-Path: <linux-kernel-owner+w=401wt.eu-S1756182Ab0ATCHM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756182Ab0ATCHM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 21:07:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756125Ab0ATCHI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 21:07:08 -0500
Received: from hera.kernel.org ([140.211.167.34]:52732 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756102Ab0ATCHG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 21:07:06 -0500
Message-ID: <4B5666B4.6000804@kernel.org>
Date: Wed, 20 Jan 2010 11:13:08 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: =?UTF-8?B?Q2VuZ2l6IEfDvG5heQ==?= <cgunay@emory.edu>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Robert Hancock <hancockrwd@gmail.com>
Subject: Re: sata_nv times out for BD-ROM iHOS104-08
References: <Pine.LNX.4.64.0912221105010.5876@stg.biology.emory.edu> 	<4B31C8EE.3030003@kernel.org> <d2d378040912232302u4b550dap687fcadced237935@mail.gmail.com> 	<4B331771.3090309@kernel.org> <d2d378041001161334r6fe3ee65w39cf98a6c2d1d399@mail.gmail.com>
In-Reply-To: <d2d378041001161334r6fe3ee65w39cf98a6c2d1d399@mail.gmail.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 20 Jan 2010 02:07:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Cengiz.

On 01/17/2010 06:34 AM, Cengiz Günay wrote:
> 2009/12/24 Tejun Heo <tj@kernel.org>:
>> I don't think the controller has anything to do with the issue but
>> just in case can you please try it with a different controller?
> 
> I tried the iHOS BD-ROM with a VIA VT6412 SATA controller today and it worked:

Hmm.... it worked?  Does kernel parameter sata_nv.adma_enabled=0 make
any difference?  Can you please attach boot log with the kernel
parameter specified?

Thanks.

-- 
tejun
