Return-Path: <linux-kernel-owner+w=401wt.eu-S966410AbXEGUET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966410AbXEGUET (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 16:04:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965509AbXEGUEQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 16:04:16 -0400
Received: from wr-out-0506.google.com ([64.233.184.230]:49943 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934562AbXEGUEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 16:04:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=R1UlyN8xoLfDfLc3pSLzXME4vbiIVZn0T1KUrLGYYhe0+REEuYDEXgqSsGFUzeYtnpewqcigx+yLqri2+ThRcrIbgOZE/3dNvIKvZnsQJVVFoFwswBHqgMjMH0TgOdFfdtw0Nvg9hArBEvT1RBtYvgVd7xQxGp6I7EhRBwOJo3Y=
Message-ID: <a781481a0705071304m7f6d1b7ewa179e291f52689a4@mail.gmail.com>
Date: Tue, 8 May 2007 01:34:11 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Pavel Machek" <pavel@ucw.cz>
Subject: Re: [PATCH 8/8] One Laptop Per Child power/battery driver
Cc: "David Woodhouse" <dwmw2@infradead.org>, "Anton Vorontsov" <cbou@mail.ru>,
       "Greg KH" <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       kernel-discuss@handhelds.org, "Andrew Morton" <akpm@osdl.org>
In-Reply-To: <20070507194949.GB3981@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070503213303.GH20067@zarina> <20070507140453.GD3868@ucw.cz>
	 <1178550653.11851.191.camel@pmac.infradead.org>
	 <20070507194949.GB3981@ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/8/07, Pavel Machek <pavel@ucw.cz> wrote:
> On Mon 2007-05-07 16:10:53, David Woodhouse wrote:
> > On Mon, 2007-05-07 at 14:04 +0000, Pavel Machek wrote:
> > > Can we stick to ascii in sources?
> >
> > No. Please join us in the 21st century.
>
> We had this discussion before. Kernel sources should be us-ascii.
> utf-8 is ok for documentation.

Hmmm ... what if David was German and had a couple of umlauts in his
name :-) One would expect to at least _spell_ his own name properly in
his code. Sources need to take care of that too (but we better stick
to only UTF-8 for source files, wouldn't want to introduce ISO-8859-1
into the mix too :-)
