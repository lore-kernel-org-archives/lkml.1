Return-Path: <linux-kernel-owner+w=401wt.eu-S1755132AbZELJHI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755132AbZELJHI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 05:07:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753021AbZELJGz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 05:06:55 -0400
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:33038 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300AbZELJGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 05:06:54 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Greg KH <gregkh@suse.de>
Subject: Re: linux-next: Tree for May 7
Date: Tue, 12 May 2009 11:06:52 +0200
User-Agent: KMail/1.9.9
Cc: Forest Bond <forest@alittletooquiet.net>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
References: <20090507171918.4ecdd6fd.sfr@canb.auug.org.au> <200905071541.28639.borntraeger@de.ibm.com> <20090507140331.GC21250@suse.de>
In-Reply-To: <20090507140331.GC21250@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905121106.52896.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Thursday 07 May 2009 16:03:31 schrieb Greg KH:
[...]
> > > > can we please remove the wpactl.c.bak file from drivers/staging/vt6655/ ?
[...]
> I'll remove it from your patch that is in the staging tree.  But I'm on
> the road right now, so that's not going to happen until Friday afternoon
> at the earliest...

Ping.

The bak file is still there. My tooling (and myself) find it disturbing to
have a dirty localversion after a "make distclean"

Christian
