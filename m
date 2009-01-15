Return-Path: <linux-kernel-owner+w=401wt.eu-S1760005AbZAOQrn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760005AbZAOQrn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 11:47:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752814AbZAOQrf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 11:47:35 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:2224 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752710AbZAOQre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 11:47:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=LhGeZ2+b+iXwEBoEWUkg+R4jA834BTzvN6m6peKR6OZ5cDP4MSL8w4vYKBp8e9Yi48
         rJGMwIw6nQa+Uc3R9GdKkFF3c5jMx56XDLVxhM2neLWf/N6eV4/0dYzLPg95LssH5DmD
         mpIkJ4IkiSDee39Pv2SOSkqyiB2jNZ2BXuKcM=
Message-ID: <8db1092f0901150847n264918c9ydf4d24a730eeedb4@mail.gmail.com>
Date: Thu, 15 Jan 2009 17:47:31 +0100
From: "Maciej Rutecki" <maciej.rutecki@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: Latest git - BUG: using smp_processor_id() in preemptible [00000000]
In-Reply-To: <8db1092f0901150842l62c77d3ci565f2c2eb09826f5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8db1092f0901150842l62c77d3ci565f2c2eb09826f5@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/1/15 Maciej Rutecki <maciej.rutecki@gmail.com>:
> Suspend to ram and disk works  OK now, on latest git

Hmm. Only on PC. Laptop still can't resume from s2ram (its wake up
itself). S2disk also doesn't work.

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
