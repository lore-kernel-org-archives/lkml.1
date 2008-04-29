Return-Path: <linux-kernel-owner+w=401wt.eu-S1759656AbYD2RA6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759656AbYD2RA6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 13:00:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753633AbYD2RAu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 13:00:50 -0400
Received: from smtp-out.google.com ([216.239.33.17]:57866 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863AbYD2RAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 13:00:49 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=SdtgZyLld4NEC7fSFlLN2aXJyicZVYrGbL5pIiZdpqT0awS3joDo/Xrutc06qRPQ8
	FrXXaE6/JyqYE5epbcpPw==
Message-ID: <d43160c70804291000k5de1b657sc1f381e08ecaeb07@mail.gmail.com>
Date: Tue, 29 Apr 2008 13:00:29 -0400
From: "Ross Biro" <rossb@google.com>
To: balbir@linux.vnet.ibm.com
Subject: Re: Page Faults slower in 2.6.25-rc9 than 2.6.23
Cc: "Hugh Dickins" <hugh@veritas.com>, linux-mm@kvack.org,
       lkml <linux-kernel@vger.kernel.org>,
       "Kamalesh Babulal" <kamalesh@linux.vnet.ibm.com>
In-Reply-To: <48175005.90400@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <d43160c70804290610t2135a271hd9b907529e89e74e@mail.gmail.com>
	 <Pine.LNX.4.64.0804291447040.5058@blonde.site>
	 <661de9470804290752w1dc0cfb3k72e81d828a45765e@mail.gmail.com>
	 <d43160c70804290821i2bb0bc17m21b0c5838631e0b8@mail.gmail.com>
	 <Pine.LNX.4.64.0804291629410.23101@blonde.site>
	 <48175005.90400@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2008 at 12:42 PM, Balbir Singh
<balbir@linux.vnet.ibm.com> wrote:
> Aah.. Yes... but I am definitely interested in figuring out the root cause for
> the regression.

I can't reproduce the 2.6.23 results.  I'm going to run the benchmarks
a few more times, but I'm suspecting something changed with the
hardware.

    Ross
