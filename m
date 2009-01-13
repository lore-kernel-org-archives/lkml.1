Return-Path: <linux-kernel-owner+w=401wt.eu-S1757362AbZAMC2L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757362AbZAMC2L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 21:28:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754097AbZAMC1z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 21:27:55 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:40953 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753984AbZAMC1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 21:27:54 -0500
Subject: Re: linux-next: Tree for January 12 (cifs vs. staging)
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: Valdis.Kletnieks@vt.edu
Cc: Steve French <smfrench@gmail.com>, Greg KH <gregkh@suse.de>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, sfrench@samba.org
In-Reply-To: <37759.1231812066@turing-police.cc.vt.edu>
References: <20090112154539.4857f533.sfr@canb.auug.org.au>
	 <496B899E.7060605@oracle.com>
	 <524f69650901121058g73c8022eif1d1bcca5c0e01fa@mail.gmail.com>
	 <20090112191330.GC7111@suse.de>
	 <524f69650901121307v67047946yed2c56efaaa839a1@mail.gmail.com>
	 <37759.1231812066@turing-police.cc.vt.edu>
Content-Type: text/plain
Date: Mon, 12 Jan 2009 20:27:49 -0600
Message-Id: <1231813669.6868.3.camel@norville.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-01-12 at 21:01 -0500, Valdis.Kletnieks@vt.edu wrote:
> On Mon, 12 Jan 2009 15:07:48 CST, Steve French said:
> 
> > I have changed the names of cifs's md5 functions in the cifs-2.6.git tree
> > 
> > diff --git a/fs/cifs/md5.h b/fs/cifs/md5.h
> > index f7d4f41..6fba8cb 100644
> 
> I presume there will be another git commit immediately following to fix
> up the call sites?

The git tree has the entire fix.  Steve's post just contained a piece of
it.

Shaggy
-- 
David Kleikamp
IBM Linux Technology Center

