Return-Path: <linux-kernel-owner+w=401wt.eu-S1758968AbYDTTux@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758968AbYDTTux (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 15:50:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755833AbYDTTum
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 15:50:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43628 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755602AbYDTTum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 15:50:42 -0400
Message-ID: <480B9DB4.8030702@zytor.com>
Date: Sun, 20 Apr 2008 15:47:00 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
CC: Andi Kleen <andi@firstfloor.org>, mingo@elte.hu, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] x86: remove unused code and data in nexgen.c
References: <1208660074-7324-1-git-send-email-dmitri.vorobiev@gmail.com>	<1208660074-7324-3-git-send-email-dmitri.vorobiev@gmail.com>	<480AC505.1030301@zytor.com> <877ies9x6b.fsf@basil.nowhere.org> <480B9856.3040902@gmail.com> <480B9ADD.9060105@zytor.com> <480B9D67.7060606@gmail.com>
In-Reply-To: <480B9D67.7060606@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitri Vorobiev wrote:
> 
> OK, then please drop this patch from the series (the other changes are OK,
> I presume), and I'll try to take care of NexGen removal with a separate patch.
> 

Acked-by: H. Peter Anvin <hpa@zytor.com>

... on the rest.

	-hpa
