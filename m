Return-Path: <linux-kernel-owner+w=401wt.eu-S1754437AbYJXJNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754437AbYJXJNS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 05:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751688AbYJXJNE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 05:13:04 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41286 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751096AbYJXJND (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 05:13:03 -0400
Message-ID: <4901916D.6070500@redhat.com>
Date: Fri, 24 Oct 2008 05:12:13 -0400
From: Chris Snook <csnook@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Joe Damato <ice799@gmail.com>
CC: linux-x86_64@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: x86: newb question - how to build everything which deps on x86
References: <49016A44.8040901@gmail.com>
In-Reply-To: <49016A44.8040901@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Damato wrote:
> There are probably more things in the kernel that depend on x86 and 
> might break with my change. Is there some config flag I can flip to 
> build all x86 related things? I tried a few patterns with grep, but I 
> just want to make sure I don't break anyone's stuff.

make allyesconfig or make allmodconfig

