Return-Path: <linux-kernel-owner+w=401wt.eu-S1765078AbXFFLuS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765078AbXFFLuS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 07:50:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762345AbXFFLuG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 07:50:06 -0400
Received: from nz-out-0506.google.com ([64.233.162.232]:23439 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762323AbXFFLuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 07:50:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=LBnwDDBUJU34V3P9WyUK/rHyT8ROS7/tsz+4g3JigL8U5/IRXSC46YMUpvT7RTBbG8nXPcQ646bTcjbnMbuyzs7vV58gmtzegAjnf/bxRVUdt89ROnVoGf+99ZSHhgZ8xKno3DOZ/6joVR4o0+t+HnXLpIaM+ZYkiMFxzYA3UlA=
Message-ID: <9a8748490706060449s1df41fd5qbd77f6fa07289eaa@mail.gmail.com>
Date: Wed, 6 Jun 2007 13:49:58 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Andy Whitcroft" <apw@shadowen.org>
Subject: Re: [PATCH] update checkpatch.pl to version 0.03
Cc: "Andrew Morton" <akpm@osdl.org>, "Randy Dunlap" <rdunlap@xenotime.net>,
       "Joel Schopp" <jschopp@austin.ibm.com>, linux-kernel@vger.kernel.org
In-Reply-To: <0a25fd03117c678f17006c5fcefaaed0@pinky>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <0a25fd03117c678f17006c5fcefaaed0@pinky>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06/07, Andy Whitcroft <apw@shadowen.org> wrote:
>
> This version brings a host of changes to cure false positives and
> bugs detected on patches submitted to lkml and -mm.  It also brings
> a number of new tests in response to reviews, of particular note:
>
A  chmod +x scripts/checkpatch.pl  would be nice :)

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
