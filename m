Return-Path: <linux-kernel-owner+w=401wt.eu-S1763336AbYBNS3d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763336AbYBNS3d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 13:29:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758053AbYBNS3N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 13:29:13 -0500
Received: from rv-out-0910.google.com ([209.85.198.189]:54245 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756774AbYBNS3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 13:29:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=uQ1gqqAk1NQvPFi1tZkSLwPzAZJXymYSoZFUhb64tNJfTXXMA1f4EtB1KBdDkOQr4WiW9q1Rk5M7ja7u90IYDiJ3d2NdADZMDrNvQc1SMh5Am+iPnnMjhQ7tkvvP30aLf8GVIlcBQx9HNdLppyzdoGdt2WWPhQSwNjWdR1xlMqw=
Message-ID: <86802c440802141029w5b409b9bl6a2dbc377ea913f2@mail.gmail.com>
Date: Thu, 14 Feb 2008 10:29:08 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Stephen Rothwell" <sfr@canb.auug.org.au>
Subject: Re: linux-next: first tree
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080215003537.8911ce35.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080215003537.8911ce35.sfr@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2008 at 5:35 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi all,
>
>  I have created the first cut of the linux-next tree at
>  git://git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git.
>
>  Things to know about this tree:
>
>  It has two branches - master and stable.  Stable is currently just Linus'
>  tree and will never rebase.  Master will rebase on an almost daily basis
>  (maybe slower at the start).

can you make stable rebase too?

so we make git-bisect working by fold in some obvious bug fix.

or that is linux-stable tree?

YH
