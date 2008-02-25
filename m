Return-Path: <linux-kernel-owner+w=401wt.eu-S1756130AbYBYS1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756130AbYBYS1S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 13:27:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754204AbYBYS1H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 13:27:07 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:36101 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753856AbYBYS1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 13:27:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:content-transfer-encoding:in-reply-to:user-agent:from;
        b=NJBfZ/tbc1ajBtqRn94jx2LiVt07y0FVN0yH2bUuTHMkjurQX5Pd1g3QxL3FGf6QxGt9NyPZKB/AKF25667aZtTHrfnQxnWBfaK0IvAs4VXfjdfSv9qMQj8+miozNYBMfPxFI5O4dBxPn8khdEsXaSY2DoZDat08ZvKF3aM9P6k=
Date: Mon, 25 Feb 2008 20:24:18 +0200
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.25-rc3: Reported regressions from 2.6.24
Message-ID: <20080225182418.GA3140@ubuntu>
References: <200802250241.40832.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200802250241.40832.rjw@sisk.pl>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2008 at 02:41:40AM +0100, Rafael J. Wysocki wrote:
> This message contains a list of some regressions from 2.6.24 reported since
> 2.6.25-rc1 was released, for which there are no fixes in the mainline I know
> of.  If any of them have been fixed already, please let me know.
> 
> If you know of any other unresolved regressions from 2.6.24, please let me know
> either and I'll add them to the list.  Also, please let me know if any of the
> entries below are invalid.
> 

There's an lguest Oops reported here:

http://lkml.org/lkml/2008/2/24/136

and a patch in the same report. It's not yet approved by Rusty, but
Ingo thinks it's fine.

Regards,

-- 

"Better to light a candle, than curse the darkness"

Ahmed S. Darwish
Homepage: http://darwish.07.googlepages.com
Blog: http://darwish-07.blogspot.com

