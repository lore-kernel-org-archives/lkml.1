Return-Path: <linux-kernel-owner+w=401wt.eu-S1759497AbZEHHuU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759497AbZEHHuU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 03:50:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755587AbZEHHuG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 03:50:06 -0400
Received: from mx2.redhat.com ([66.187.237.31]:49203 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754582AbZEHHuE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 03:50:04 -0400
Message-ID: <4A03E3B4.8080600@redhat.com>
Date: Fri, 08 May 2009 10:48:04 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: joseph.cihula@intel.com
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, arjan@linux.intel.com,
       hpa@zytor.com, andi@firstfloor.org, chrisw@sous-sol.org,
       jmorris@namei.org, jbeulich@novell.com, peterm@redhat.com,
       gang.wei@intel.com, shane.wang@intel.com, sheng@linux.intel.com
Subject: Re: [RFC v3][PATCH 1/2] intel_txt: KVM shutdown fix
References: <4A03B9BD.8020205@intel.com>
In-Reply-To: <4A03B9BD.8020205@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joseph Cihula wrote:
> Fix KVM to disable itself under all shutdown conditions.  In additional to being good practice, Intel(R) TXT requires VMX to be disabled on all CPUs in order for TXT to be disabled.
>   

This is already in kvm.git, as f878b14017f.



-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

