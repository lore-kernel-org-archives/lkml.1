Return-Path: <linux-kernel-owner+w=401wt.eu-S1758614AbXH0TMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758614AbXH0TMT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 15:12:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754341AbXH0TMI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 15:12:08 -0400
Received: from an-out-0708.google.com ([209.85.132.247]:53403 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754199AbXH0TMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 15:12:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=tm09u+6ZyaBDD4C8LKFCt03QaHOr+KeB8eduRt5fR30cKqwcT+1qyPbIfMtm9n4rPTdlAlpC50Ms3OrHKnXG8mvEI3ZiEmtuIBdoGIUV07kpGgifmhhYee4pDeZ7hm5hsQlRRkIINvsQ2g+TTruEbYg0xkDU6C0aeHHyK8hoC9w=
Message-ID: <72dbd3150708271212w6bcca4c4web26d7cb25892afc@mail.gmail.com>
Date: Mon, 27 Aug 2007 12:12:06 -0700
From: "David Rees" <drees76@gmail.com>
To: "Daniel Walker" <dwalker@mvista.com>
Subject: Re: Who wants to maintain KR list for stable releases? (was Re: nmi_watchdog=2 regression in 2.6.21)
Cc: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "=?ISO-8859-1?Q?Bj=F6rn_Steinbrink?=" <B.Steinbrink@gmx.de>,
       eranian@hpl.hp.com, ak@suse.de, linux-kernel@vger.kernel.org,
       "Natalie Protasevich" <protasnb@gmail.com>
In-Reply-To: <1188229197.2435.207.camel@dhcp193.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1186531609.22044.50.camel@imap.mvista.com>
	 <1187628296.7732.14.camel@imap.mvista.com>
	 <46CDE94A.7000600@googlemail.com>
	 <1187904169.2435.83.camel@dhcp193.mvista.com>
	 <46D21E8E.4000003@googlemail.com>
	 <20070827005131.b93f5935.akpm@linux-foundation.org>
	 <6bffcb0e0708270438j4c92a0b4m1396b4010f25bfb5@mail.gmail.com>
	 <1188227585.2435.192.camel@dhcp193.mvista.com>
	 <6bffcb0e0708270826p7a7fb044re53d0db4094bc3d5@mail.gmail.com>
	 <1188229197.2435.207.camel@dhcp193.mvista.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/27/07, Daniel Walker <dwalker@mvista.com> wrote:
> Now that I'm looking at the kernel bugzilla .. If you set the kernel
> version to 2.6.22 and set the "Regression" check box you could denote
> the fact that it's a regression in that kernel version ..
>
> I don't know if this URL is going to come out right,
>
> <snip url>
>
> That should be open bugs , kernel version 2.6.22, with the regression
> check box set ..
>
> So you may not need a master tracking bug ..

Yep, that's another way to do it. The method I described earlier is
commonly used when you don't have the handy regression field in
bugzilla. The technique is handy for creating lists for tracking other
types of issues which don't necessarily fall into a component and you
don't want to bother customizing bugzilla.

I also suspect that there will be a number of common searches that
many people will find useful. With recent versions of bugzilla (3.0+)
you can share searches within groups, but it may be helpful to have a
wiki or some other page where useful searches can be stored, or one of
the templates edited to include those common searches.

-Dave
