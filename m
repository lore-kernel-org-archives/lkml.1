Return-Path: <linux-kernel-owner+w=401wt.eu-S1756756AbYEDMb1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756756AbYEDMb1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 08:31:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755350AbYEDMbT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 08:31:19 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:56732
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755089AbYEDMbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 08:31:19 -0400
Message-ID: <481DAC94.4050506@qumranet.com>
Date: Sun, 04 May 2008 15:31:16 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: "Zhang, Xiantao" <xiantao.zhang@intel.com>
CC: Al Viro <viro@ZenIV.linux.org.uk>, sfr@canb.auug.org.au,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       kvm-ia64-devel@lists.sourceforge.net, Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [kvm-ia64-devel] [PATCH] ia64 kvm fixes for O=... builds
References: <E1JqMOH-0004ky-VF@ZenIV.linux.org.uk>	<42DFA526FC41B1429CE7279EF83C6BDC011CA51F@pdsmsx415.ccr.corp.intel.com>	<20080428141402.GD5882@ZenIV.linux.org.uk>	<20080428182416.GE5882@ZenIV.linux.org.uk> <42DFA526FC41B1429CE7279EF83C6BDC011CAECD@pdsmsx415.ccr.corp.intel.com>
In-Reply-To: <42DFA526FC41B1429CE7279EF83C6BDC011CAECD@pdsmsx415.ccr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zhang, Xiantao wrote:
> Hi, Airo
>     Currenlty,  We only allow CONFIG_KVM_INTEL = m , since it needs to
> be relocated at insertion time. 
>   

In many ways this module is more like firmware than a standard kernel 
module, no?

-- 
error compiling committee.c: too many arguments to function

