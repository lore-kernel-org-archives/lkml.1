Return-Path: <linux-kernel-owner+w=401wt.eu-S1754844AbZJNFUP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844AbZJNFUP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 01:20:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752259AbZJNFUO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 01:20:14 -0400
Received: from mail.perches.com ([173.55.12.10]:2135 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751608AbZJNFUM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 01:20:12 -0400
Subject: Re: Moving drivers into staging (was Re: [GIT PULL] SCSI fixes for
 2.6.32-rc3)
From: Joe Perches <joe@perches.com>
To: Greg KH <gregkh@suse.de>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       James Bottomley <James.Bottomley@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jing Huang <huangj@brocade.com>, netdev@vger.kernel.org,
       linux-wireless@vger.kernel.org
In-Reply-To: <20091014044519.GA19199@suse.de>
References: <alpine.LFD.2.01.0910081410400.3432@localhost.localdomain>
	 <20091009091538.GA4154@elte.hu>
	 <1255097287.2934.21.camel@localhost.localdomain>
	 <20091012130652.GB25464@elte.hu>
	 <1255357148.2850.91.camel@localhost.localdomain>
	 <20091012145453.GD4565@elte.hu> <20091012150911.GB1656@suse.de>
	 <20091012154244.GA13323@elte.hu> <20091012232429.GA24254@suse.de>
	 <43e72e890910131108m789110b4hc35e25601ad67bb7@mail.gmail.com>
	 <20091014044519.GA19199@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 13 Oct 2009 22:19:35 -0700
Message-Id: <1255497575.1851.16.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-10-13 at 21:45 -0700, Greg KH wrote:
> How about when it was scheduled to be removed, we put it in staging and
> I'll add it to my announcements about the staging tree every release?
> Unless you can think of a better way?

staging/to_be_removed_unless_fixed_by/v.x.y ?


