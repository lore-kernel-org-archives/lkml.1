Return-Path: <linux-kernel-owner+w=401wt.eu-S1752497AbZFIEPT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752497AbZFIEPT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 00:15:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751042AbZFIEPG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 00:15:06 -0400
Received: from smtp-out.google.com ([216.239.33.17]:42624 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834AbZFIEPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 00:15:04 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=LCiY2UQuiTaTiygCP70ByYY2otTx/gwov1EDrt3trXIpSHQl32XVRLpDQE+B1nfs7
	2FwYLXTEUGvYteoWZZvIw==
MIME-Version: 1.0
In-Reply-To: <6601abe90906051442t294c2e79i3c6dc38c1d53e5e0@mail.gmail.com>
References: <4A28F83F.4030704@tuffmail.co.uk> <4A292E61.3050204@gmail.com>
	 <20090605180125.GB6442@mit.edu>
	 <6601abe90906051442t294c2e79i3c6dc38c1d53e5e0@mail.gmail.com>
Date: Mon, 8 Jun 2009 21:15:01 -0700
Message-ID: <532480950906082115u77918911m2d44953014053c9b@mail.gmail.com>
Subject: Re: Mild filesystem corruption on ext4 (no journal)
From: Michael Rubin <mrubin@google.com>
To: Curt Wohlgemuth <curtw@google.com>
Cc: Theodore Tso <tytso@mit.edu>, Aioanei Rares <krnl.list@gmail.com>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>, linux-ext4@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 5, 2009 at 2:42 PM, Curt Wohlgemuth<curtw@google.com> wrote:
> Just FYI: Frank Mayhar has recreated this issue in a recent kernel
> (though we're not seeing it with our 2.6.26 kernel + ext4 patches),
> and is actively working on it.

Sorry about this. We had a bunch of sick engineers in the last week or
so (including Frank). Hopefully he will be able to devote time to this
bug as he is getting back. We need it fixed for ourselves so we are
going to root cause it if no one beats us to it.

mrubin
