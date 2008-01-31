Return-Path: <linux-kernel-owner+w=401wt.eu-S933032AbYAaMtp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933032AbYAaMtp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 07:49:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764530AbYAaMtf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 07:49:35 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:64370 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754966AbYAaMte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 07:49:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=gO31xqD6FmA2yXMMn/okeee7u81vEpE0t0zAq1jNhC019EpUPRvDxrwDcKm4U8JiNPV44J2Ym39eAY5VuE0aR5ktqP2sGEJfffml4j3qt72hC0/kuLjwUYO+gzet6rCgmSJ1EJ8UYkgr/DiLKmXDnp/d8mh6cXcoAwC2abqbJcA=
Message-ID: <3d8471ca0801310449y426742b8yf711c7859b105469@mail.gmail.com>
Date: Thu, 31 Jan 2008 13:49:32 +0100
From: "Guillaume Chazarain" <guichaz@yahoo.fr>
To: "Peter Zijlstra" <a.p.zijlstra@chello.nl>
Subject: Re: High wake up latencies with FAIR_USER_SCHED
Cc: vatsa@linux.vnet.ibm.com, "Ingo Molnar" <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, dhaval@linux.vnet.ibm.com
In-Reply-To: <1201776461.28547.289.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3d8471ca0801271201o5a41955cg552ef06a2f821285@mail.gmail.com>
	 <20080128023129.GD1044@linux.vnet.ibm.com>
	 <3d8471ca0801280857m2ea8518ds2ad8d5346f756a0e@mail.gmail.com>
	 <3d8471ca0801281213l5ec62984i763afb22216cb423@mail.gmail.com>
	 <1201776461.28547.289.camel@lappy>
X-Google-Sender-Auth: a103b499a37b1530
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/31/08, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> Does something like this help?

I made it compile by open coding undefined macros instead of
refactoring the whole file.
But it didn't affect wake up latencies.

Thanks.

-- 
Guillaume
