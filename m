Return-Path: <linux-kernel-owner+w=401wt.eu-S1754193AbYHRLCY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193AbYHRLCY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 07:02:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752062AbYHRLCF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 07:02:05 -0400
Received: from mail.free-electrons.com ([88.191.46.45]:49159 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943AbYHRLCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 07:02:01 -0400
Date: Mon, 18 Aug 2008 13:01:58 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, neilb@suse.de,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for August 13 (nfsd)
Message-ID: <20080818130158.1e01928a@surf>
In-Reply-To: <20080814111633.55f5f1e8@surf>
References: <20080813172452.14b0775c.sfr@canb.auug.org.au>
	<20080813104748.13848196.randy.dunlap@oracle.com>
	<20080813180931.GC26765@fieldses.org>
	<20080814111633.55f5f1e8@surf>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le Thu, 14 Aug 2008 11:16:33 +0200,
Thomas Petazzoni <thomas.petazzoni@free-electrons.com> a écrit :

> > Looks like that's just two more functions that need to be stubbed
> > out in the case where CONFIG_FILE_LOCKING is undefined?--hopefully
> > Thomas Petazzoni (cc'd) could be talked into reproducing this and
> > sending me an incremental fix....
> 
> Here is an incremental fix.

Does it work for you ?

Sincerly,

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers and embedded Linux development,
consulting, training and support.
http://free-electrons.com
