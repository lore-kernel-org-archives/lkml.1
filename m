Return-Path: <linux-kernel-owner+w=401wt.eu-S1755439AbZBKB3n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439AbZBKB3n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 20:29:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753865AbZBKB3c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 20:29:32 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:47687 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754629AbZBKB3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 20:29:31 -0500
Date: Wed, 11 Feb 2009 01:29:25 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, James Morris <jmorris@namei.org>,
       Mimi Zohar <zohar@us.ibm.com>
Subject: Re: linux-next: Tree for February 10 (security/audit/ima)
Message-ID: <20090211012925.GC28946@ZenIV.linux.org.uk>
References: <20090210194121.80256b72.sfr@canb.auug.org.au> <4991DBA0.1000008@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4991DBA0.1000008@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 10, 2009 at 11:55:12AM -0800, Randy Dunlap wrote:
> Stephen Rothwell wrote:
> > Hi all,
> > 
> > Changes since 20090209:
> > 
> > Dropped trees (temporarily):
> > 	audit (difficult conflicts)
> 
> 
> Maybe this is fixed by the dropped audit tree?

Everything in the public audit tree is applied, AFAICT (and for-{linus,next}
is reset to current mainline HEAD to avoid the conflicts; sorry about
that).
