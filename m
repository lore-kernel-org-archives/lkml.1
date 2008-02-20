Return-Path: <linux-kernel-owner+w=401wt.eu-S1755007AbYBTHK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755007AbYBTHK2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 02:10:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750814AbYBTHKU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 02:10:20 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:58741 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811AbYBTHKT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 02:10:19 -0500
To: yanmin_zhang@linux.intel.com
Subject: Re: Linux 2.6.25-rc2
X-IlohaMail-Blah: penberg@cs.helsinki.fi
X-IlohaMail-Method: mail() [mem]
X-IlohaMail-Dummy: moo
X-Mailer: IlohaMail/0.8.12+pk-11 (On: iloha.cs.Helsinki.FI)
In-Reply-To: <1203490390.3248.48.camel@ymzhang>
Message-ID: <VZM3JorJ.1203491417.8617180.penberg@cs.helsinki.fi>
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
CC: "Ingo Molnar" <mingo@elte.hu>,
       "Mathieu Desnoyers" <mathieu.desnoyers@polymtl.ca>,
       "Torsten Kaiser" <just.for.lkml@googlemail.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Christoph Lameter" <clameter@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Date: Wed, 20 Feb 2008 09:10:17 +0200 (EET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 2/20/2008, "Zhang, Yanmin" <yanmin_zhang@linux.intel.com> wrote:
> Kernel with the reverting patch is ok.
> I ran reboot/hackbench for more than 10 times on every one of my 3 x86-64 
> machines, and kernel didn't crash.

Great, Linus reverted the patch yesterday. Thanks for testing!
