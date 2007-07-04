Return-Path: <linux-kernel-owner+w=401wt.eu-S1758804AbXGDA2p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758804AbXGDA2p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 20:28:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751300AbXGDA2e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 20:28:34 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:51451 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754271AbXGDA2a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 20:28:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=EZevvh8wwnUZMMVvBjtL01/TTr0rklxJkzPlfZXgLFEv0p2O0DecKFd06ZWtNQx63psbh/wqb5bXYTZj8+Fb4k4En7DoDBMKmmZXFFDUEmwIDhOaR30m0CCji56Mmk0xycHl/nrAyuyBXHEH7dOzSO/7cLyh/dhCK1oSY4ndbZA=
Message-ID: <7fe698080707031728j3a0091c9y73344a573667b65b@mail.gmail.com>
Date: Wed, 4 Jul 2007 09:28:29 +0900
From: "Dongjun Shin" <djshin90@gmail.com>
To: "=?ISO-8859-1?Q?J=F6rn_Engel?=" <joern@logfs.org>
Subject: Re: vm/fs meetup in september?
Cc: "Jared Hulbert" <jaredeh@gmail.com>,
       "Christoph Hellwig" <hch@infradead.org>,
       "Nick Piggin" <npiggin@suse.de>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Linux Memory Management List" <linux-mm@kvack.org>,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <20070703122522.GB11942@lazybastard.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <20070624042345.GB20033@wotan.suse.de>
	 <6934efce0706251708h7ab8d7dal6682def601a82073@mail.gmail.com>
	 <20070626060528.GA15134@infradead.org>
	 <6934efce0706261007x5e402eebvc528d2d39abd03a3@mail.gmail.com>
	 <20070630093243.GD22354@infradead.org>
	 <6934efce0707021044x44f51337ofa046c85e342a973@mail.gmail.com>
	 <20070702230418.GA5630@lazybastard.org>
	 <6934efce0707021746q133c62f5l803e5fa78b3535d9@mail.gmail.com>
	 <20070703122522.GB11942@lazybastard.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'd like to reference a paper titled "FASS : A Flash-Aware Swap System".
(http://kernel.kaist.ac.kr/~jinsoo/publication/iwssps05.pdf)

The paper describes a technique that uses NAND flash as a swap device
without FTL (Flash Translation Layer) or filesystem.

It is not related with XIP, however.

On 7/3/07, Jörn Engel <joern@logfs.org> wrote:
> On Mon, 2 July 2007 17:46:40 -0700, Jared Hulbert wrote:
> >
> > Right, the solution to swap problem is identical to the rw XIP
> > filesystem problem.    Jörn, that's why you're the self-appointed
> > subject matter expert!
>
> All right.  I'll try to make an important face whenever the subject
> comes up.
>
> Nick, do you have a problem if LogFS occupies two brainslots at the
> meeting?
>
