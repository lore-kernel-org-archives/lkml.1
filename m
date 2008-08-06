Return-Path: <linux-kernel-owner+w=401wt.eu-S1030356AbYHFUex@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030356AbYHFUex (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 16:34:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756056AbYHFUcz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 16:32:55 -0400
Received: from mail.atheros.com ([12.36.123.2]:32216 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755489AbYHFUcy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 16:32:54 -0400
Date: Wed, 6 Aug 2008 13:32:51 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Luis Rodriguez <Luis.Rodriguez@atheros.com>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
       Jochen =?iso-8859-1?B?Vm/f?= <jochen.voss@googlemail.com>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "ath9k-devel@venema.h4ckr.net" <ath9k-devel@venema.h4ckr.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linville@tuxdriver.com" <linville@tuxdriver.com>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 2/4] list.h: add list_cut_position()
Message-ID: <20080806203251.GB9519@tesla>
References: <1217890089-12100-1-git-send-email-lrodriguez@atheros.com> <20080804160011.ec964f1f.randy.dunlap@oracle.com> <20080804231320.GG6447@tesla> <ef1cd66f0808050152g1dd8b96cl2df820607d480f0f@mail.gmail.com> <20080806182724.GI5605@tesla> <23052053.1218047754579.JavaMail.oracle@acsmt304.oracle.com> <20080806184520.GK5605@tesla> <20080806202854.GP5605@tesla>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080806202854.GP5605@tesla>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 06, 2008 at 01:28:54PM -0700, Luis Rodriguez wrote:
> On Wed, Aug 06, 2008 at 11:45:20AM -0700, Luis Rodriguez wrote:
> >
> > OK here's the new one.
> > --
> >
> > This adds list_cut_position() which lets you cut a list into
> > two lists given a pivot in the list.
> >
> > Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> 
> Here it is again but this time one which applies cleanly ontop of the
> list_cut_tail() patch I just reposted.

I meant on top of the list_splice_tail() of course :)

  Luis
