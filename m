Return-Path: <linux-kernel-owner+w=401wt.eu-S965834AbXCPSs4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965834AbXCPSs4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 14:48:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965838AbXCPSs4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 14:48:56 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:4216 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965834AbXCPSs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 14:48:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=CDFqTey5DYlKjyonh3TZtM+TfIThjF9s77TQZVONR0r9/KQQBH+8Babh1pFHw3sbZBm4A/cGS66RSTR/R5iWwMlUBwQhF5+ZBANVsxO+nt/0o2ccffrYdXoHnyH+JqMWDR1I4kA8Ykk5Pv0iicHx0+3PIuS5yg4dFWQo0Co0eoI=
Message-ID: <3d8471ca0703161148mb8df568xb2c380bdc67a58b1@mail.gmail.com>
Date: Fri, 16 Mar 2007 19:48:50 +0100
From: "Guillaume Chazarain" <guichaz@gmail.com>
To: "Andi Kleen" <ak@suse.de>
Subject: Re: [PATCH] Add an offset in the cyc2ns computation to fix sched_clock jumps
Cc: "john stultz" <johnstul@us.ibm.com>, mathieu.desnoyers@polymtl.ca,
       linux-kernel@vger.kernel.org
In-Reply-To: <200703161922.13450.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3d8471ca0703161114o7ad654car60c1a6b801401149@mail.gmail.com>
	 <200703161922.13450.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/3/16, Andi Kleen <ak@suse.de>:
> I already fixed this myself in a similar way (but didn't push it out yet)

Out of insatiable curiosity, I'd be interested in seeing what the
patch looks like
if you agree.

Thanks.

-- 
Guillaume
