Return-Path: <linux-kernel-owner+w=401wt.eu-S1755103AbYJXTL0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755103AbYJXTL0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 15:11:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753242AbYJXTLS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 15:11:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38487 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930AbYJXTLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 15:11:18 -0400
Message-ID: <49021DD2.2070504@zytor.com>
Date: Fri, 24 Oct 2008 12:11:14 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Uros Bizjak <ubizjak@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH, x86]: Implement change_bit with immediate operand as
 "lock xorb"
References: <5787cf470810240501j3522e8c8ld9a8498ff1bfef21@mail.gmail.com>
In-Reply-To: <5787cf470810240501j3522e8c8ld9a8498ff1bfef21@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Uros Bizjak wrote:
> Hello!
> 
> Implement change_bit with immediate bit count as "lock xorb". This is
> similar to  "lock orb" and "lock andb"  for set_bit and clear_bit
> functions.
> 

Looks good, but please resubmit your patch with a Signed-off-by: line 
and Cc: x86@kernel.org on the submission.

Thanks!

	-hpa
