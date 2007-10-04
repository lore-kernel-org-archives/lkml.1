Return-Path: <linux-kernel-owner+w=401wt.eu-S1762540AbXJDXTD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762540AbXJDXTD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 19:19:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757438AbXJDXSw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 19:18:52 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34914 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755585AbXJDXSv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 19:18:51 -0400
Message-ID: <470574D7.6070605@redhat.com>
Date: Thu, 04 Oct 2007 19:18:47 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Derek Fawcus <dfawcus@cisco.com>
CC: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Version 3 (2.6.23-rc8) Smack: Simplified Mandatory Access
   Control Kernel
References: <46FEEBD4.5050401@schaufler-ca.com> <20070930011618.ccb8351b.akpm@linux-foundation.org> <Xine.LNX.4.64.0710010146100.13671@us.intercode.com.au> <alpine.LFD.0.999.0710010803280.3579@woody.linux-foundation.org> <1191253239.7672.76.camel@moss-spartans.epoch.ncsc.mil> <alpine.LFD.0.999.0710010854120.3579@woody.linux-foundation.org> <4702B1D5.5050502@tmr.com> <alpine.LFD.0.999.0710021410470.3579@woody.linux-foundation.org> <alpine.LFD.0.999.0710021615520.3579@woody.linux-foundation.org> <20071003011246.7313facb@the-village.bc.nu> <20071004235600.A4177@mrwint.cisco.com>
In-Reply-To: <20071004235600.A4177@mrwint.cisco.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/2007 06:56 PM, Derek Fawcus wrote:
> 
> I ran firefox setuid to a different (not my main user),  uid+gid,  gave
> my main account that gid as a supplemental group,  and gave that uid
> access to the X magic cookie.

You need to use runxas to get any kind of real security.
