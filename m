Return-Path: <linux-kernel-owner+w=401wt.eu-S1761996AbYECKNv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761996AbYECKNv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 06:13:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763578AbYECKNX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 06:13:23 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:16686 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763415AbYECKNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 06:13:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=MlfNm4nMuQ9jG8ttMyYwwjdYY7I4ME2hQha5loh8vEhav98mPQTxq63K8M6kh9O3yW+scbqCtRu/KlF3NLEQwxZifwxbxeDwa+pI469fW9sQa0+rIZyf0wX3eeY8sseE5wiPFVt89uMnE3P48r2R2LO6wLpl3hFfbOJXIM1LILE=
Message-ID: <ed10ee420805030313r457d8cdfjdbcb346ae928c125@mail.gmail.com>
Date: Sat, 3 May 2008 03:13:21 -0700
From: "SL Baur" <steve@xemacs.org>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: How to reduce the number of open kernel bugs
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080502124210.GB5838@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080502124210.GB5838@cs181133002.pp.htv.fi>
X-Google-Sender-Auth: baca44ab830dd73c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/2/08, Adrian Bunk <bunk@kernel.org> wrote:
> Just seen in the kernel Bugzilla (driver anonymized to foobar):

 ... An all too common sequence

This is the kind of stuff that naturally happens when you tie performance
to the progression of bug reports through bug tracking systems.  It's
human nature.

It's not good, but it's human nature.  This situation is *not* unique to Linux.

-sb (My day job is the care and feeding of a Fortune 50 company's internal bug
tracking system)
