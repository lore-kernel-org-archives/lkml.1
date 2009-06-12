Return-Path: <linux-kernel-owner+w=401wt.eu-S932809AbZFLIDs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932809AbZFLIDs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 04:03:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754542AbZFLID2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 04:03:28 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:53097 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753835AbZFLIDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 04:03:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=l6KhK5Q5e7l2u9PVKS0iGXaFwio4oAc/5JFQQV9UtYmr8iATriEzFCtK2LSV7CyPp1
         zrf4+WkDMz3VIJ1GG77DVHkNkLH6dsHgSctZxjnqZnzql1xzQQOZyzXxSPjXvkgLD1m3
         7XmmKLTtiha4ObMlUBgI4TjVgwhvMTkuDEdjs=
Date: Fri, 12 Jun 2009 10:03:23 +0200
From: Borislav Petkov <petkovbb@googlemail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-kernel@vger.kernel.org, borislav.petkov@amd.com
Subject: Re: [GIT PULL] AMD64 EDAC module for 2.6.31
Message-ID: <20090612080323.GA14669@liondog.tnic>
Mail-Followup-To: Borislav Petkov <petkovbb@gmail.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-kernel@vger.kernel.org, borislav.petkov@amd.com
References: <20090611103705.GC15454@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20090611103705.GC15454@aftab>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

now that amd64 EDAC is upstream, I've removed the fox-next branch since
the next patch series is not ready yet.

What is actually the proper way to let you know that I don't have any
more patches for linux-next right now and that you don't have to pull
from my repo for now?

Thanks.

-- 
Regards/Gruss,
    Boris.
