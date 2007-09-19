Return-Path: <linux-kernel-owner+w=401wt.eu-S1762847AbXISSrl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762847AbXISSrl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 14:47:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755455AbXISSre
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 14:47:34 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:2187 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753271AbXISSrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 14:47:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=RDXahtorpwNUgzCiiCqzzbOJtI5cJYRd8Qyzx1HYpPj8HUC3Jq6aH34LkXk+QioyoWMEUYoUu6cUFN2VSVrQSMJHtuKD+vp0yC7/LbA3qA668kmDpOuIfO9CihEM2l29ZWDjzH8BN27g5D0qVGw/IBiBOlaJFpWCmZ7PYsOEWIc=
Message-ID: <43e72e890709191147h63d4d780l7091e7baefc8345d@mail.gmail.com>
Date: Wed, 19 Sep 2007 14:47:31 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Tim Bird" <tim.bird@am.sony.com>
Subject: Re: [Announce] Linux-tiny project revival
Cc: "linux kernel" <linux-kernel@vger.kernel.org>,
       linux-tiny <Linux-tiny@selenic.com>,
       "CE Linux Developers List" <celinux-dev@tree.celinuxforum.org>,
       "Michael Opdenacker" <michael@free-electrons.com>
In-Reply-To: <46F1645D.9050406@am.sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46F1645D.9050406@am.sony.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/19/07, Tim Bird <tim.bird@am.sony.com> wrote:
> Recently, the CE Linux forum has been working to revive the
> Linux-tiny project.  At OLS, I asked for interested parties
> to volunteer to become the new maintainer for the Linux-tiny patchset.
>
> A few candidates came forward, but eventually Michael Opdenacker
> was selected as the new primary maintainer.  A few other
> people, including John Cooper of Wind River and myself
> are working to support this effort.
>
> Recently, many of the Linux-tiny patches have been brought up-to-date
> and are now available for use with a 2.6.22 kernel.  The intent
> is to test these, and begin mainlining the most effective sub-patches,
> in the next few months.
>
> Some automated testing has already been set up, with some
> preliminary results published at a CELF conference in Japan.
> (See the linux-tiny page below for a link to the presentation.)
> Hopefully, results publishing will also be automated soon.
>
> We encourage anyone with interest in this project to get involved.
> If you have ideas how to reduce the static or dynamic memory footprint
> of Linux, or, even better, patches for this, please let us know about
> them.
>
> Please see http://elinux.org/Linux_Tiny
>
> A related document: http://elinux.org/Kernel_Size_Tuning_Guide
> is undergoing an update this week.

Will there be a separate git for testing? Is the idea to still keep
moving patches upstream?

  Luis
