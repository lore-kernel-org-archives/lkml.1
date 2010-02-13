Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757078Ab0BMADE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 19:03:04 -0500
Received: from mail-yw0-f179.google.com ([209.85.211.179]:56600 "EHLO
	mail-yw0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755174Ab0BMADA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 19:03:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=lkzRVbndGUn2iLJHxloGR61HbAWSV5AnQONjcojwZ7cBnveFqMoCarsfgulFfUu+gD
         LfofvH/CSBA1tk80ekOGd3O4+HEc6lMWHYo9/ow0NxVvF1tbaws6XuiXxVen+37zpLqb
         o8M+1trZsgqye2/yFXmB/AnseFDFBLst9s3Ks=
MIME-Version: 1.0
In-Reply-To: <1266014143-29444-7-git-send-email-jason.wessel@windriver.com>
References: <1266014143-29444-1-git-send-email-jason.wessel@windriver.com> 
	<1266014143-29444-7-git-send-email-jason.wessel@windriver.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Fri, 12 Feb 2010 19:02:39 -0500
Message-ID: <8bd0f97a1002121602p5bc21d2td99aa4c00a103b2d@mail.gmail.com>
Subject: Re: [PATCH 06/28] kgdb,blackfin: Add in kgdb_arch_set_pc for blackfin
To: Jason Wessel <jason.wessel@windriver.com>
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       mingo@elte.hu, Mike Frysinger <vapier@gentoo.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 12, 2010 at 17:35, Jason Wessel wrote:
> The new debug core api requires all architectures that use to debug
> core to implement a function to set the program counter.
>
> CC: Mike Frysinger <vapier@gentoo.org>

sorry, thought i Acked-by this already ...
-mike
