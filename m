Return-Path: <linux-kernel-owner+w=401wt.eu-S1756004AbZJLKaZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756004AbZJLKaZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 06:30:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755259AbZJLKaY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 06:30:24 -0400
Received: from mail-pz0-f188.google.com ([209.85.222.188]:43179 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755057AbZJLKaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 06:30:24 -0400
Message-ID: <4AD304B2.8000205@vflare.org>
Date: Mon, 12 Oct 2009 15:58:02 +0530
From: Nitin Gupta <ngupta@vflare.org>
Reply-To: ngupta@vflare.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [ARM] force dcache flush if dcache_dirty bit set
References: <1255337423-3158-1-git-send-email-ngupta@vflare.org> <20091012090710.GA29310@n2100.arm.linux.org.uk>
In-Reply-To: <20091012090710.GA29310@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12/2009 02:37 PM, Russell King - ARM Linux wrote:
> On Mon, Oct 12, 2009 at 02:20:23PM +0530, Nitin Gupta wrote:
>> Same problem exists on mips too.
> 
> Nice catch.  This logic came from sparc64, so I think you'd want to talk
> to davem about it as well.
> 
> In the mean time, submitting your fix to the patch system would be great,
> thanks.
> 

Thanks for looking into this. I think this can make it to mainline if
you could Ack it and perhaps CC Andrew to get his attention?

I will soon post similar patch for mips. For sparc64, I guess David wants to fix it.

Thanks,
Nitin
