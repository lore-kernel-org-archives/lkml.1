Return-Path: <linux-kernel-owner+w=401wt.eu-S1030981AbXD1Drk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030981AbXD1Drk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 23:47:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030984AbXD1Drk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 23:47:40 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:36834 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030981AbXD1Drj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 23:47:39 -0400
Date: Sat, 28 Apr 2007 05:47:49 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Roland Dreier <rdreier@cisco.com>
Cc: Dave Jones <davej@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: checkpatch, a patch checking script.
Message-ID: <20070428034749.GG3468@stusta.de>
References: <20070423141123.GA21174@skybase> <20070423104534.51bac974.akpm@linux-foundation.org> <20070425112133.4ae86399.randy.dunlap@oracle.com> <20070425143011.57247c1d.akpm@linux-foundation.org> <20070425172447.1576c399.akpm@linux-foundation.org> <20070426003911.GA19383@redhat.com> <4630109F.6090002@oracle.com> <20070425200207.77a2721a.akpm@linux-foundation.org> <20070428030805.GA13331@redhat.com> <ada1wi5npam.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ada1wi5npam.fsf@cisco.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2007 at 08:36:17PM -0700, Roland Dreier wrote:
>...
> Also, it would be nice to be able to do something like
> 
>     git diff v2.6.20..|perl ~/checkpatch.pl -
>...

  perl ~/checkpatch.pl <(git diff v2.6.20..)

>  - R.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

