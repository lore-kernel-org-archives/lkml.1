Return-Path: <linux-kernel-owner+w=401wt.eu-S1759593AbYDCQSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759593AbYDCQSR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 12:18:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756528AbYDCQSG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 12:18:06 -0400
Received: from saeurebad.de ([85.214.36.134]:59728 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756451AbYDCQSF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 12:18:05 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Hugh Dickins <hugh@veritas.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, mingo@elte.hu, davem@davemloft.net,
       hskinnemoen@atmel.com, cooloney@kernel.org, starvik@axis.com,
       dhowells@redhat.com, ysato@users.sourceforge.net, takata@linux-m32r.org,
       ralf@linux-mips.org, kyle@parisc-linux.org, paulus@samba.org,
       schwidefsky@de.ibm.com, lethal@linux-sh.org, jdike@addtoit.com,
       miles@gnu.org, chris@zankel.net, rmk@arm.linux.org.uk,
       tony.luck@intel.com, akpm@linux-foundation.org
Subject: Re: [RFC 10/22] m68k: Use generic show_mem()
References: <12071688283927-git-send-email-hannes@saeurebad.de>
	<1207168941186-git-send-email-hannes@saeurebad.de>
	<Pine.LNX.4.64.0804030939320.9848@anakin>
	<87myobp02g.fsf@saeurebad.de>
	<Pine.LNX.4.64.0804031538150.11898@anakin>
	<87wsnfnfdu.fsf@saeurebad.de>
	<Pine.LNX.4.64.0804031705230.11465@blonde.site>
Date: Thu, 03 Apr 2008 18:17:54 +0200
In-Reply-To: <Pine.LNX.4.64.0804031705230.11465@blonde.site> (Hugh Dickins's
	message of "Thu, 3 Apr 2008 17:07:32 +0100 (BST)")
Message-ID: <874paioqtp.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Hugh Dickins <hugh@veritas.com> writes:

> On Thu, 3 Apr 2008, Johannes Weiner wrote:
>> 
>> Sorry for the wasted time.  These cleanups already took more energy than
>> they are worth it, I guess... :/
>
> Please do persist, I for one appreciate your efforts on this:
> something I wanted to do years ago but never yet got around to.
>
> Thank you!
> Hugh

Thanks a lot!

I will do a removal of redundant output for every show_mem() based on my
prior patches first and then give the generic version another shot.

Thanks for all your comments so far.

	Hannes
