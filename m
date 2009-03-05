Return-Path: <linux-kernel-owner+w=401wt.eu-S1757865AbZCEX3a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757865AbZCEX3a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 18:29:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757877AbZCEX2U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 18:28:20 -0500
Received: from hera.kernel.org ([140.211.167.34]:45304 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757848AbZCEX2S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 18:28:18 -0500
Message-ID: <49B05FAE.8050107@kernel.org>
Date: Thu, 05 Mar 2009 15:26:38 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: Prakash Punnoor <prakash@punnoor.de>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Robert Hancock <hancockrwd@gmail.com>, david@lang.hm,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org
Subject: Re: [PATCH] pci: don't enable too many HT MSI mapping
References: <alpine.DEB.1.10.0902171419000.26625@asgard.lang.hm> <49AA4389.8010605@kernel.org> <200903010929.17904.prakash@punnoor.de> <200903040815.38387.prakash@punnoor.de> <20090305171514.GB1021@parisc-linux.org>
In-Reply-To: <20090305171514.GB1021@parisc-linux.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:
> On Wed, Mar 04, 2009 at 08:15:37AM +0100, Prakash Punnoor wrote:
>> 2.6.29-rc7 is released, but the last two patches here in the thread have not 
>> been picked up. Why?
> 
> Oh, I meant to say ... we're at -rc7.  What is the danger here of this
> fixing your machine but breaking somebody else's?  Is there something we
> can minimally do that fixes your machine today and then put in a patch
> for 30-rc1 that is likely to fix other machines?
> 

please don't apply v3 and prakash patch at this point.

will have one better v4 this weekend.

YH
