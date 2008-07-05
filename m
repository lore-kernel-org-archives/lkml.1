Return-Path: <linux-kernel-owner+w=401wt.eu-S1755161AbYGEGpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755161AbYGEGpb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 02:45:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752116AbYGEGpR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 02:45:17 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51134 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129AbYGEGpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 02:45:16 -0400
Subject: Re: [bug?] tg3: Failed to load firmware "tigon/tg3_tso.bin"
From: Jaswinder Singh <jaswinder@infradead.org>
To: Jeff Garzik <jeff@garzik.org>, David Woodhouse <dwmw2@infradead.org>,
       Takashi Iwai <tiwai@suse.de>, Hugh Dickins <hugh@veritas.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, mchan@broadcom.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Andrew Morton <akpm@linux-foundation.org>, netdev@vger.kernel.org
Content-Type: text/plain
Date: Sat, 05 Jul 2008 12:07:58 +0530
Message-Id: <1215239879.4136.12.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-Bad-Reply: 'Re:' in Subject but no References or In-Reply-To headers
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Respected Jeff,

On Sat, Jul 5, 2008 at 11:44 AM, Jeff Garzik <jeff@garzik.org> wrote:
> David Woodhouse wrote:
>>
>> I'm working on making the required firmware get installed as part of
>> 'make modules_install'.
>
> Great!  That will definitely reduce silent regressions due to build process
> changes.

If other issues are solved, please look at the code of TG3 firmware Patch :-

http://git.infradead.org/users/dwmw2/firmware-2.6.git?a=commitdiff;h=be4e9388e35b22d6f8aa104baf39f8339825424e

And give us your valuable feedback regarding code :)

Can I move to another net drivers ?

Thank you,

Jaswinder Singh.

