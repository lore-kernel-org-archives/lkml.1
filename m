Return-Path: <linux-kernel-owner+w=401wt.eu-S1757527AbYAEU7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757527AbYAEU7T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 15:59:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756732AbYAEU7H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 15:59:07 -0500
Received: from an-out-0708.google.com ([209.85.132.251]:34091 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755922AbYAEU7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 15:59:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=m9OOuVwSe0do3IulINYSLX2uwJBu60gzVulOFzuUDp0te5JQLiErJ42g7dqcKWIxutoMauSzmdVvkB6+uC3oLz026J/3gXizx9RKjRAYfRqtWO+nnzYzBcTiIwtw8lJOjiy1dZx5FvWu7uSiiCFuLKwJee5k5r6hvR/69bzQrvM=
Message-ID: <c384c5ea0801051259r6bf7c10ai552f1988bae44c6f@mail.gmail.com>
Date: Sat, 5 Jan 2008 21:59:03 +0100
From: "Leon Woestenberg" <leon.woestenberg@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [ANNOUNCE] util-linux-ng 2.13.1-rc2
Cc: "Karel Zak" <kzak@redhat.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, util-linux-ng@vger.kernel.org
In-Reply-To: <20080105013121.c8bf01ed.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080102211052.GC23824@petra.dvoda.cz>
	 <20080105013121.c8bf01ed.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Jan 5, 2008 10:31 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Wed, 2 Jan 2008 22:10:52 +0100 Karel Zak <kzak@redhat.com> wrote:
> >  The second util-linux-ng 2.13.1 release candidate is available at
> >
> >     ftp://ftp.kernel.org/pub/linux/utils/util-linux-ng/
> >
>
> Interesting.  Thanks.  Which distros are using this, or plan to do so?
>
I have added util-linux-ng to the OpenEmbedded project a few days ago,
so any distro in there can switch over.

Regards,
-- 
Leon
