Return-Path: <linux-kernel-owner+w=401wt.eu-S932308AbZHCWqG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932308AbZHCWqG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 18:46:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754956AbZHCWqG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 18:46:06 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:49204 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753106AbZHCWqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 18:46:05 -0400
Date: Mon, 3 Aug 2009 18:38:34 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: davem@davemloft.net, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2009-08-03
Message-ID: <20090803223834.GA26385@tuxdriver.com>
References: <20090803205954.GE11441@tuxdriver.com> <43e72e890908031406u1e15f074h173e4806daab343f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <43e72e890908031406u1e15f074h173e4806daab343f@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 03, 2009 at 02:06:19PM -0700, Luis R. Rodriguez wrote:
> On Mon, Aug 3, 2009 at 1:59 PM, John W. Linville<linville@tuxdriver.com> wrote:
> > Dave,
> >
> > Here is another round of fixes intended for 2.6.31.  The one from
> > Reinette fixes an rfkill-related bug described in bugzilla 13742.  The one
> > from Luis has a lengthy changelog, but boils down to correcting some
> > regulatory enforcement issues that would prevent some devices from
> > working in some localities.  The rest are simple and obvious.
> >
> > Please let me know if there are problems!
> >
> > Thanks,
> >
> > John
> >
> > ---
> >
> > Individual patches are available here:
> >
> >        http://www.kernel.org/pub/linux/kernel/people/linville/wireless-2.6/
> 
> John, just noticed the patches in this link do not correspond.

Thanks -- corrected now (as soon as the resync happens)...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
			¡Viva Honduras Libre!
