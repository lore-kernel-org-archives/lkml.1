Return-Path: <linux-kernel-owner+w=401wt.eu-S1759822AbYEKWSU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759822AbYEKWSU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 18:18:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755522AbYEKWSM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 18:18:12 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:26459 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754124AbYEKWSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 18:18:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=a2FijoC+MRmd8DxuBdGe+UJrgJCls3EzxZIA7I4jQzYZ9179FVtBVowMg1QqLOy39NUU3kJr2/lgfIOhI1gJ3xzH7P1v0mCpy28A2fcnPvsM9pGVYOKgjlZ07hMSLQTFODrSFUlATWBioO21Kvpd1XowhRpIGyWLpVbrXBsVnMM=
Message-ID: <a44ae5cd0805111518u7743cc5dw2a60168a420363b2@mail.gmail.com>
Date: Sun, 11 May 2008 18:18:09 -0400
From: "Miles Lane" <miles.lane@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #10628] 2.6.26-rc1-git1 -- trying to get vblank count for disabled pipe 0
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>
In-Reply-To: <88YBFoyd1CN.A.yR.fw1JIB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <hPXlJLjt4XG.A._lF.Jv1JIB@chimera>
	 <88YBFoyd1CN.A.yR.fw1JIB@chimera>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I will check asap.  I am pretty busy with unpacking boxes after moving.

On Sun, May 11, 2008 at 4:04 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.25.  Please verify if it still should be listed.
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=10628
> Subject         : 2.6.26-rc1-git1 -- trying to get vblank count for disabled pipe 0
> Submitter       : Miles Lane <miles.lane@gmail.com>
> Date            : 2008-05-04 21:12 (8 days old)
> References      : http://lkml.org/lkml/2008/5/4/309
> Handled-By      : Jesse Barnes <jbarnes@virtuousgeek.org>
>
>
>
