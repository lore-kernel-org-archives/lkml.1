Return-Path: <linux-kernel-owner+w=401wt.eu-S1756031AbYHYKNZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031AbYHYKNZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 06:13:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753822AbYHYKNR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 06:13:17 -0400
Received: from 41-052.adsl.zetnet.co.uk ([194.247.41.52]:47738 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752736AbYHYKNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 06:13:16 -0400
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com, adobriyan@gmail.com
Subject: Re: Writable packet CD-RW mounting broken in 2.6.26 by your commit 68154e90c9d1492d570671ae181d9a8f8530da55
References: <8763pr1jy0.fsf_-_@hades.wkstn.nix>
	<20080824144827R.fujita.tomonori@lab.ntt.co.jp>
	<871w0eb9nx.fsf@hades.wkstn.nix>
	<20080825143125M.fujita.tomonori@lab.ntt.co.jp>
From: Nix <nix@esperi.org.uk>
Emacs: the Swiss Army of Editors.
Date: Mon, 25 Aug 2008 11:12:09 +0100
In-Reply-To: <20080825143125M.fujita.tomonori@lab.ntt.co.jp> (FUJITA Tomonori's message of "Mon, 25 Aug 2008 14:32:51 +0900")
Message-ID: <87wsi5769y.fsf@hades.wkstn.nix>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.5-b28 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-DCC-sonic.net-Metrics: hades 1156; Body=4 Fuz1=4 Fuz2=4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 Aug 2008, FUJITA Tomonori verbalised:

> On Sun, 24 Aug 2008 18:33:06 +0100
> Nix <nix@esperi.org.uk> wrote:
>> I suspect this is -stable material, right?
>
> Yes, there are the same bugs in 2.6.26.

I was testing in 2.6.26, so yes, they're definitely there.

> I added the Cc: stable tag on the patches so they will go to the
> stable tree as soon as they get merged into mainline, I think.
>
> Again, sorry about these bugs and thanks for the investigation.

Hey, everyone has bugs. Not everyone can get them fixed in ~6hrs
in the early morning .jp time :) so I think you come out ahead on
this one.

-- 
`Not even vi uses vi key bindings for its command line.' --- PdS
