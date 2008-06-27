Return-Path: <linux-kernel-owner+w=401wt.eu-S932080AbYF0Sc1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932080AbYF0Sc1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 14:32:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761931AbYF0Sbz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 14:31:55 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:64182 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760879AbYF0Sby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 14:31:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=q0Y3R2PCffAbGH8Q+B2AZU1MiorXnyBrKfhu714+9bm/dlNholUQGwSsHIoIIsB74T
         iYRHEGSCjUZzjGSB4n9m16DmwU2nUYdV+jGqyZrUDiNf6Kps5MXdNg203/e5ig8yRGZB
         LYvfRgeEZI7OSFraRRDimK25v/q2UupxoCTJo=
Message-ID: <86802c440806271131q2fe2c2cubea2c810b99b9302@mail.gmail.com>
Date: Fri, 27 Jun 2008 11:31:53 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Bernhard Walle" <bwalle@suse.de>
Subject: Re: [PATCH 2/2] Use FIRMWARE_MEMMAP on x86/E820
Cc: x86@kernel.org, kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       vgoyal@redhat.com, gregkh@suse.de
In-Reply-To: <20080627131415.4d482af2@halley.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1214511542-28458-1-git-send-email-bwalle@suse.de>
	 <1214511542-28458-3-git-send-email-bwalle@suse.de>
	 <86802c440806261354y673a5521ie615feafae3b2bd8@mail.gmail.com>
	 <20080627131415.4d482af2@halley.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2008 at 4:14 AM, Bernhard Walle <bwalle@suse.de> wrote:
> * Yinghai Lu [2008-06-26 13:54]:
>>
>> looks good...
>>
>> will produce one patch update early_reserve_e820_mpc_new or
>> early_reserve_e820 to update e820_saved too. that contained updated
>> mptable for second kernel without acpi support.
>
> You or me? I don't understand ...

after your patch are merged into tip, I will produce one patch to fix
early_reserve_e820...

YH
