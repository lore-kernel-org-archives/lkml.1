Return-Path: <linux-kernel-owner+w=401wt.eu-S1758086AbXGMLhL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758086AbXGMLhL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 07:37:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755009AbXGMLg6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 07:36:58 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:21738 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753817AbXGMLg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 07:36:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:reply-to:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=BSm+R+Anifmk8aui/UyX+fWRk7EbATCoIN4YzK8SvVUUkG/OK6cXi+c4UVejMS6xK71QVssTNPjd/0tOn1094cv6MpJvPjUL6OqX5C0KUj9BsIivaFJYYfFE25QQtyCZyTrqYKJDEfrM9IY8XFQG/9pVyyNN3G6kgU3jW2OU6W0=
Message-ID: <3efb10970707130436v70ddbae2w51af0a19fa5c297c@mail.gmail.com>
Date: Fri, 13 Jul 2007 13:36:56 +0200
From: "Remy Bohmer" <l.pinguin@gmail.com>
Reply-To: linux@bohmer.net
To: "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: v2.6.22.1-rt3
Cc: LKML <linux-kernel@vger.kernel.org>,
       RT-Users <linux-rt-users@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <1184325752.12353.312.camel@chaos>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1184325752.12353.312.camel@chaos>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,

>  http://www.tglx.de/projects/preempt-rt/2.6.22.1

This is a dead link...
It should be: http://www.tglx.de/projects/preempt-rt/2.6.22.1-rt3/

Remy

>
> more info about the -rt patchset can be found in the RT wiki:
>
>    http://rt.wiki.kernel.org
>
> This release is bugfix release:
>
> - update of the x8664 -hrt queue (resolve boot problems)
> - gtod vsyscall fix from Gregory Haskins
>
> to build a 2.6.22.1-rt3 tree, the following patches should be applied:
>
>    http://kernel.org/pub/linux/kernel/v2.6/linux-2.6.22.1.tar.bz2
>    http://www.tglx.de/projects/preempt-rt/2.6.22.1-rt3/patch-2.6.22.1-rt3.patch
>
>
>         Thomas
>
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-rt-users" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
