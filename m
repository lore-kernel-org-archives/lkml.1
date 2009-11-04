Return-Path: <linux-kernel-owner+w=401wt.eu-S932777AbZKDWIb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932777AbZKDWIb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 17:08:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757609AbZKDWIa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 17:08:30 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:11747 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757608AbZKDWIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 17:08:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=AeARtjV9qF+usynoAEZpplqFsA+ChtAKNjGdX3zZhxNa5laD9rYscDo9ey6voH/8N3
         hXjeDKjpNzgBqyTQwLCuLmGjtgAD5yCZHhwd3poMv6pUZRzvFy7J9LDnujZiT3QYzwSp
         BRUDIcIXPdPO809EQf6yT41B9mi+TUggMSFvQ=
Message-ID: <4AF1FB69.4000101@gmail.com>
Date: Wed, 04 Nov 2009 14:08:41 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Spicebird/0.7.1 (X11; 2009022519)
MIME-Version: 1.0
To: Michael Gilbert <michael.s.gilbert@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: CVE-2009-2584
References: <20091104170542.e40b12ec.michael.s.gilbert@gmail.com>
In-Reply-To: <20091104170542.e40b12ec.michael.s.gilbert@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Gilbert wrote:
> Hi,
>
> CVE-2009-2584 [0],[1] has been disclosed for quite a while now (with
> existing exploit code by Brad Spengler [2]).  A patch has also been
> available for the same amount of time [3], but as of 2.6.32-rc6 it is
> still not applied.  Did this slip through the cracks?  Thanks upfront
> for any info on the matter.
>
> Best wishes,
> Mike
>
> [0] http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2009-2584
> [1] http://xorl.wordpress.com/2009/07/21/linux-kernel-sgi-gru-driver-off-by-one-overwrite/
> [2] http://grsecurity.net/~spender/exploit_demo.c
> [3] http://lkml.org/lkml/2009/7/20/348
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>    
just read something today which might
be similar/same as what you might
be referring too.
http://www.theregister.co.uk/2009/11/03/linux_kernel_vulnerability/

Justin P. Mattock


