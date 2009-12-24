Return-Path: <linux-kernel-owner+w=401wt.eu-S1756618AbZLXHWH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756618AbZLXHWH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Dec 2009 02:22:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754597AbZLXHWG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Dec 2009 02:22:06 -0500
Received: from hera.kernel.org ([140.211.167.34]:59539 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754504AbZLXHWF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Dec 2009 02:22:05 -0500
Message-ID: <4B331771.3090309@kernel.org>
Date: Thu, 24 Dec 2009 16:25:37 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: =?UTF-8?B?Q2VuZ2l6IEfDvG5heQ==?= <cgunay@emory.edu>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: sata_nv times out for BD-ROM iHOS104-08
References: <Pine.LNX.4.64.0912221105010.5876@stg.biology.emory.edu> 	<4B31C8EE.3030003@kernel.org> <d2d378040912232302u4b550dap687fcadced237935@mail.gmail.com>
In-Reply-To: <d2d378040912232302u4b550dap687fcadced237935@mail.gmail.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/24/2009 04:02 PM, Cengiz Günay wrote:
> 
> On Wed, Dec 23, 2009 at 2:38 AM, Tejun Heo <tj@kernel.org
> <mailto:tj@kernel.org>> wrote:
> 
>     Can you please try kernel parameter irqpoll?  Also, does having a
>     readable media in the drive during boot make any difference?
> 
> 
> Sorry, neither made any difference.
> 
> By the way, kernel 2.6.23.9 goes into an infinite loop at bootup with
> ata3 exception messages. I can write them down if it would help.

Hmmm... can you please take a photo?  I don't think the controller has
anything to do with the issue but just in case can you please try it
with a different controller?

Thanks.

-- 
tejun
