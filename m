Return-Path: <linux-kernel-owner+w=401wt.eu-S932835AbYDVNwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932835AbYDVNwT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 09:52:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765650AbYDVNvy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 09:51:54 -0400
Received: from hu-out-0506.google.com ([72.14.214.228]:12782 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763121AbYDVNvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 09:51:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=V786tcQXWhEVeqgtq5vYCBkGYEcHE14v5wTnORX3XylpHgHmrb4SQlDE+It7hDk5Or25fMXinwYM5oujaf5iVXdAA4x8JlyrFOJ4NiCYU4QiO9vzzgMBKBBnu2JFvjfElYOM+8PbqvO33/TBoJGQaiq7EkBMPWCvKZIIq7IgRiw=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: x86: 4kstacks default
Date: Tue, 22 Apr 2008 15:51:11 +0200
User-Agent: KMail/1.8.2
Cc: David Chinner <dgc@sgi.com>, Eric Sandeen <sandeen@sandeen.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Shawn Bohrer <shawn.bohrer@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
References: <20080419142329.GA5339@elte.hu> <200804221448.09828.vda.linux@googlemail.com> <20080422130155.GA16895@cs181133002.pp.htv.fi>
In-Reply-To: <20080422130155.GA16895@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804221551.11488.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 April 2008 15:01, Adrian Bunk wrote:
> > Sent a few.
> > I would like to ask you to ACK/NAK every individual patch
> > in some reasonable period of time, say, 1-3 days. If you NAK a patch,
> > please let me know what is wrong with it.
> >...
> 
> I know the feeling of resending patches again and again without any 
> reaction quite well, but that's not David's fault and not true for XFS 
> patches, so when you try to put pressure on him you hit the wrong 
> person.

Yeah, sorry about that. I was not implying that XFS people were
not responsive.
--
vda
