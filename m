Return-Path: <linux-kernel-owner+w=401wt.eu-S1754702AbYJCJOb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702AbYJCJOb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 05:14:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752704AbYJCJOX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 05:14:23 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:4718 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978AbYJCJOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 05:14:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=v+bwq2jTAWMfaXGKbH4P26g193JKY1hW6a/zsuKBVa1Oj36hrmDjSkKuGRyOVkA1P/
         xpv65reNZd0hoTNFWMMQh+9hQ4yrPVchK2NFcDhrE8ZqPfdyG+Ylc2RxpBYEr2krBBeK
         cnCPuzuOYDxX/3XpOyWEM/lkI4DzlWahJ72FY=
Message-ID: <4727185d0810030214t69666ea4qa2e9960283406270@mail.gmail.com>
Date: Fri, 3 Oct 2008 11:14:20 +0200
From: "Vincent Legoll" <vincent.legoll@gmail.com>
To: "Bjorn Helgaas" <bjorn.helgaas@hp.com>
Subject: Re: [PATCH] PCI probing debug message uniformization
Cc: "Jesse Barnes" <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <200810021259.05864.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4727185d0809291403w38422338p3ffe2a1c27c39939@mail.gmail.com>
	 <200810021146.28704.jbarnes@virtuousgeek.org>
	 <200810021259.05864.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 2, 2008 at 8:59 PM, Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> On Thursday 02 October 2008 12:46:28 pm Jesse Barnes wrote:
>> Bjorn, how does this jive with the various other debug harmonization patches
>> you've been putting together & reviewing?
>
> I think it's great.  The only nit I would change is to use
> "[%#llx-%#llx]" as we do in pci_request_region().
>
> Bjorn

Thanks for the review, I'll post an updated version this evening.

-- 
Vincent Legoll
