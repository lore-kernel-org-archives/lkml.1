Return-Path: <linux-kernel-owner+w=401wt.eu-S1758795AbYFPHcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758795AbYFPHcR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 03:32:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752519AbYFPHcF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 03:32:05 -0400
Received: from relay1.sgi.com ([192.48.171.29]:55341 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752250AbYFPHcE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 03:32:04 -0400
Date: Mon, 16 Jun 2008 02:32:00 -0500
From: Paul Jackson <pj@sgi.com>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: mingo@elte.hu, tglx@linutronix.de, steiner@sgi.com, travis@sgi.com,
       hpa@zytor.com, linux-kernel@vger.kernel.org, ying.huang@intel.com,
       andi@firstfloor.org, akpm@linux-foundation.org
Subject: Re: [PATCH 4/8] x86 boot: allow overlapping ebda and efi memmap
 memory ranges
Message-Id: <20080616023200.16eafc18.pj@sgi.com>
In-Reply-To: <86802c440806152354i24a1ec5ap316dacec0981d05@mail.gmail.com>
References: <20080616062945.14597.78009.sendpatchset@polaris-admin.engr.sgi.com>
	<20080616063001.14597.96170.sendpatchset@polaris-admin.engr.sgi.com>
	<86802c440806152354i24a1ec5ap316dacec0981d05@mail.gmail.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai wrote:
> how about patial overlapping?

I do not understand what you ask.

I suppose your question is a minor typo of:

> how about partial overlapping?

... however I don't understand that either - sorry.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
