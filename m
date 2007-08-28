Return-Path: <linux-kernel-owner+w=401wt.eu-S1758849AbXH1NcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758849AbXH1NcT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 09:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752838AbXH1NcI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 09:32:08 -0400
Received: from el-out-1112.google.com ([209.85.162.179]:46907 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752217AbXH1NcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 09:32:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=M/AK2y0xVK0ucI5UvRTnTv0rj81ytSMMZHncSC6AiBDIf87erkfNMevwSqm7mYFPMzSKmes/07bM7fhrhnaVUOuhyR2KQfupJyYfY+J4KKVkJQuHA1nlDnTVikqhlYsaEz8IqInJgCJ7h/ZTcsjlZoSX5sXpQUBb+kUUTx4XTrs=
Message-ID: <4877c76c0708280632t3eb40d01od1267c8c4a7d8de@mail.gmail.com>
Date: Tue, 28 Aug 2007 06:32:04 -0700
From: "Michael Evans" <mjevans1983@gmail.com>
To: "Bill Davidsen" <davidsen@tmr.com>
Subject: Re: [patch v3 1/1] md: Software Raid autodetect dev list not array
Cc: "Randy Dunlap" <randy.dunlap@oracle.com>,
       "Michael J. Evans" <mjevans1983@comcast.net>,
       "Neil Brown" <neilb@suse.de>, "Ingo Molnar" <mingo@redhat.com>,
       linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <46D421F6.50205@tmr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200708222058.45480.mjevans1983@comcast.net>
	 <200708271516.21889.mjevans1983@comcast.net>
	 <20070827153020.43788e21.randy.dunlap@oracle.com>
	 <200708272138.19785.mjevans1983@comcast.net>
	 <46D3A8AD.6000701@oracle.com>
	 <4877c76c0708280608m529296edgd83f9c08e3918815@mail.gmail.com>
	 <46D421F6.50205@tmr.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/28/07, Bill Davidsen <davidsen@tmr.com> wrote:
> Michael Evans wrote:
> > Oh, I see.  I forgot about the changelogs.  I'd send out version 5
> > now, but I'm not sure what kernel version to make the patch against.
> > 2.6.23-rc4 is on kernel.org and I don't see any git snapshots.
> > Additionally I never could tell what git tree was the 'mainline' as it
> > isn't labeled with such a keyword (at least in the list of git trees I
> > saw).
>
> I suspect you wait for 2.5.23 release, or send it to AKPM for inclusion
> in an "-mm" kernel. That's probably desirable, anyway.
>
> --
> bill davidsen <davidsen@tmr.com>
>   CTO TMR Associates, Inc
>   Doing interesting things with small computers since 1979
>
>

There's another list I should CC to?  Or does the section maintainer
do that when they're happy with the patch?
