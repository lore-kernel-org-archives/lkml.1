Return-Path: <linux-kernel-owner+w=401wt.eu-S1751482AbYAaJOc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751482AbYAaJOc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 04:14:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757454AbYAaJNh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 04:13:37 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:50387 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755477AbYAaJNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 04:13:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=epl0X+t7TtCRZJLtp0Nw91bYY/ue4DIch1NQaObSfBhBRGWlHolMV5meteMgkuHz4ztjcOxehQhBzr73htFrhT3dABLi2fat5sLPdgzHbkQZxsPpBVuVb0gOH8VhucM220ag3st3zAthtjSQOGqvXzkofiKeELtxwdlenUzuInc=
Message-ID: <86802c440801310113s4f792b70le8377440078125f4@mail.gmail.com>
Date: Thu, 31 Jan 2008 01:13:33 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Chris Snook" <csnook@redhat.com>
Subject: Re: about relocs.c on x86
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <47A187DB.5010201@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <86802c440801310007oe8693c7q177d41a87c27ca7@mail.gmail.com>
	 <47A187DB.5010201@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 31, 2008 12:33 AM, Chris Snook <csnook@redhat.com> wrote:
> Yinghai Lu wrote:
> > why not rename relocs.c to relocs_32.c?
>
> Because we're trying to get rid of all the _32 and _64 files?

but that file is not need for x86_64

YH
