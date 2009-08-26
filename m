Return-Path: <linux-kernel-owner+w=401wt.eu-S1752695AbZHZSUl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695AbZHZSUl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 14:20:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752640AbZHZSUk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 14:20:40 -0400
Received: from mail-pz0-f192.google.com ([209.85.222.192]:39986 "EHLO
	mail-pz0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631AbZHZSUj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 14:20:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=vGQ5NQlf2B6mnSFtFr08z7Vr0HhP7/+B7YdjHK8l+Z2zEAz0PhX3meCjLVeQ1o3PSS
         9L0sgj01Wo0RYv5gnJnNUs+dEvnTvF68CSmLWN7dL9l7CtSlGLDavPOOAXCTN+PYpyxC
         9kYEJ43+rLwgPr07NvDdpjXI0ZZgxpXodTzdM=
MIME-Version: 1.0
In-Reply-To: <aedb14900908261103j4cd61eabwd6a5cfb564146478@mail.gmail.com>
References: <aedb14900908261051p3dd8a580tc196728d341d02dc@mail.gmail.com>
	 <aedb14900908261103j4cd61eabwd6a5cfb564146478@mail.gmail.com>
Date: Wed, 26 Aug 2009 23:50:40 +0530
Message-ID: <1f808b4a0908261120h1a62c2e1o43891e4c26ec2803@mail.gmail.com>
Subject: Re: Student Project Idea
From: Peter Chacko <peterchacko35@gmail.com>
To: Satyam Shekhar <satyamshekhar@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As a student it helps if you come out of the inhibition that only
kernel level projects are great and other disciplines don't worth a
dime for a fresh grad. Kernel development is generally meant for
experienced developers who already did non-kernel, system level
development for some time. There are many areas which are less
glamorous, but need the application of  heavy computer science, and
un-explored  for which  a brilliant grad  student can contribute to.

Indicative list is  that i can think of off-hand is ,

1) development of multi-core aware , concurrent data structures and
algorithms that manipulate on them(  which don't need locking for
concurrency.(I mean shared-nothing, but concurrent)

2) study of performance on all system calls in a non-virtualized and
virtualized systems, as it relates to storage and network IO.

3) Addition of an integrated data compression/decompression as part of
 Disk IO when  VM images are written to disk. And you can also think
of data de-dpulication across VM images.

4)  ....and all other topics that others suggest.

A  one time kernel developer(Aix/Solaris/Windows/Linux) .


On Wed, Aug 26, 2009 at 11:33 PM, Satyam Shekhar<satyamshekhar@gmail.com> wrote:
> Hi,
>
> I am a final year undergrad student at the Indian Institute of
> Technology, Guwahati, India. I have my B.Tech project starting this
> semester. I have a keen interest in kernel development and am looking
> for topics for the project.
>
> I would be highly grateful if you could give me some suggestions or
> ideas to work on in this regard.
>
> Regards
> Satyam Shekhar
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Best regards,
Peter Chacko

NetDiox computing systems,
Network storage & OS  training and research.
Bangalore, India.
www.netdiox.com
080 2664 0708
