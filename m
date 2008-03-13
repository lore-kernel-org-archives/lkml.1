Return-Path: <linux-kernel-owner+w=401wt.eu-S1755241AbYCMM2f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755241AbYCMM2f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 08:28:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751907AbYCMM20
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 08:28:26 -0400
Received: from el-out-1112.google.com ([209.85.162.179]:5235 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807AbYCMM2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 08:28:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=RXoMyUxOHjqIiOaRaz4ERH1SnzfVJVYKDJg7cWLTgUSGo7OAcWJZdm4CUw/EJYxtMLNz7pjMVF7+rxD8nw3wnBRC01h5dxLD8dZ3LGkkmkF//cOHqDCgibYGGNN0YvPjBqruWDolKrcTfI7NvqOkQCP3J+5Sc/MglIJqq07Fs3Q=
Message-ID: <80b317760803130528n2aa80728l86290f3af8d9ab21@mail.gmail.com>
Date: Thu, 13 Mar 2008 13:28:24 +0100
From: "Richard Genoud" <richard.genoud@gmail.com>
To: "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>
Subject: Re: [BUG] PLEXTOR DVDR PX-740A drive not ready for command
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Borislav Petkov" <petkovbb@googlemail.com>
In-Reply-To: <200803131337.17095.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47D8F73F.4090501@gmail.com>
	 <200803131337.17095.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Could we get full dmesg for this particular system/problem?
>
>  Please also;
>  - test 2.6.25-rc5 on _your_ system
>  - verify that configuration of hda and hdb devices is correct
>   (master/slave settings)
>
> There is far too much information there (different error messages,
>  different host drivers, some systems are using libata...) - please
>  open a new bug entry at http://bugzilla.kernel.org so we can start
>  "clean" and fully concentrate on fixing this bug.
>

Ok, I will test that this evening and open a bug entry.

Richard.
