Return-Path: <linux-kernel-owner+w=401wt.eu-S1755087AbXLVNcE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755087AbXLVNcE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 08:32:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751555AbXLVNby
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 08:31:54 -0500
Received: from rv-out-0910.google.com ([209.85.198.189]:42919 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233AbXLVNby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 08:31:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=lWn0e3DWPwvUweWIeltpjBrrU8lkGXU+MlrS0GT6r+/NP3miInUf9YhNHwwjcX/Ok/CV8LGldoKGGl9tD+G508ONfHW/Tb7B5YSV9ku6YrTElfbAas+Nl0cJK6r0WZQYMuwH0Siz0N8sIskqqK+frc6Q16q5X2oSyQH4jIn6xqY=
Message-ID: <84144f020712220531x238da99bi19ff06aaddfc5fc3@mail.gmail.com>
Date: Sat, 22 Dec 2007 15:31:53 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] slub: /proc/slabinfo ABI compatibility
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       andi@firstfloor.org, clameter@sgi.com, a.p.zijlstra@chello.nl
In-Reply-To: <20071222131456.GA32558@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0712221446280.24655@sbz-30.cs.Helsinki.FI>
	 <20071222131456.GA32558@elte.hu>
X-Google-Sender-Auth: e762cc2fd3960f09
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On Dec 22, 2007 3:14 PM, Ingo Molnar <mingo@elte.hu> wrote:
> Also please apply the cleanup patch below, it fixes 34 checkpatch errors
> and warnings in mm/slub.c.

Those are already fixed in -mm:

http://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc5/2.6.24-rc5-mm1/broken-out/slub-fix-coding-style-violations.patch
http://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc5/2.6.24-rc5-mm1/broken-out/slub-fix-coding-style-violations-checkpatch-fixes.patch

                                Pekka
