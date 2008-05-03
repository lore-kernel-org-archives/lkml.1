Return-Path: <linux-kernel-owner+w=401wt.eu-S1758857AbYECOsW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758857AbYECOsW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 10:48:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755825AbYECOsM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 10:48:12 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:57319 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755054AbYECOsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 10:48:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=MEqSIQWnLr4MLUkeX5nU1KkvliBW+sjyqOy3A5kwEoiRSOh96ODjMHOOsFfitqeBBAqPL7P7+4DE6TDnISNbyi48g0fJfhwPj+JcTm9oMCx2pz5JhalUaocNdzTNgszXytubDFCVRjWjW86XH1wZlurpvIW1wHPQ6kuaRpQWoQc=
Message-ID: <e2e108260805030748yea75e79xf421b70fc4a625e1@mail.gmail.com>
Date: Sat, 3 May 2008 16:48:08 +0200
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "Matthew Wilcox" <matthew@wil.cx>
Subject: Re: SCSI target subsystem
Cc: "FUJITA Tomonori" <tomof@acm.org>,
       "James Bottomley" <James.Bottomley@hansenpartnership.com>,
       "Christoph Hellwig" <hch@infradead.org>, linux-scsi@vger.kernel.org,
       scst-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       "Vladislav Bolkhovitin" <vst@vlnb.net>
In-Reply-To: <20080503132846.GA14976@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200805021638.42972.bart.vanassche@gmail.com>
	 <e2e108260805020853r4c21fb98y3d4434a7fc95989c@mail.gmail.com>
	 <20080502155525.GA16353@infradead.org>
	 <e2e108260805020906w7f5e92bev46b8d0f96aa7b4d6@mail.gmail.com>
	 <1209745084.3121.39.camel@localhost.localdomain>
	 <481B5AB8.5030108@vlnb.net>
	 <e2e108260805030241w216363dbt4b5f6b2105ad267b@mail.gmail.com>
	 <20080503095314.GX14976@parisc-linux.org>
	 <e2e108260805030339q4fcaedf7t34e737c14801e788@mail.gmail.com>
	 <20080503132846.GA14976@parisc-linux.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 3, 2008 at 3:28 PM, Matthew Wilcox <matthew@wil.cx> wrote:
> Once Vladislav is ready for his project to be merged, let him approach
> us and ask.  I don't know if he considers his project ready for merging.
> Did he ask you for his help?  It's generally considered rather rude to
> merge someone else's code without their consent.  The way you tried to
> get it merged was unhelpful and, if Vladislav were less skillful a
> communicator, could have actively hindered getting it merged.

You'd better verify your assumptions before you take them for truth. I
asked Vladislav for permission by private e-mail before I posted the
scsi_execute_async_fifo() patch. Did try I to merge this code without
Vladislav's consent ? No. Anyone can see that I kept Vladislav and the
scst-devel mailing list in CC.

Let us return to the actual topic of this thread. Does the above mean
that you agree with inclusion of SCST in the mainline kernel ? It
still has to be decided who will maintain the mainline kernel SCSI
target code. In the past James wrote that he does not really have the
time for this. Until now the only one who volunteered to maintain such
a subsystem is Vladislav.

Bart.
