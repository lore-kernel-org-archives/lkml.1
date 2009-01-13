Return-Path: <linux-kernel-owner+w=401wt.eu-S1758106AbZAMBVW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758106AbZAMBVW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 20:21:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757131AbZAMBVN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 20:21:13 -0500
Received: from relay2.sgi.com ([192.48.179.30]:42975 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756989AbZAMBVN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 20:21:13 -0500
Message-ID: <496BEC86.1070701@sgi.com>
Date: Mon, 12 Jan 2009 17:21:10 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Mike Frysinger <vapier.adi@gmail.com>
CC: Ingo Molnar <mingo@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8] irq: update all archs to use new irq_desc cpumask_var_t's.
References: <20090112220519.566749000@polaris-admin.engr.sgi.com> <8bd0f97a0901121407ude0b816i2ebd36c3d24036e9@mail.gmail.com>
In-Reply-To: <8bd0f97a0901121407ude0b816i2ebd36c3d24036e9@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Frysinger wrote:
> On Mon, Jan 12, 2009 at 17:05, Mike Travis wrote:
>> Cc: Bryan Wu <cooloney@kernel.org>
> 
> Blackfin CC should be more uclinux-dist-devel@blackfin.uclinux.org
> -mike

I saw that but it's flagged:

L:      uclinux-dist-devel@blackfin.uclinux.org (subscribers-only)

I assumed that means the list does not want unsolicited mail?

Thanks,
Mike

