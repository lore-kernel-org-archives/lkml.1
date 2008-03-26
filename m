Return-Path: <linux-kernel-owner+w=401wt.eu-S1757938AbYCZJzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757938AbYCZJzA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 05:55:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753995AbYCZJyw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 05:54:52 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:58037
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753629AbYCZJyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 05:54:52 -0400
Message-ID: <47EA1C63.8010202@qumranet.com>
Date: Wed, 26 Mar 2008 11:50:27 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Dave Hansen <haveblue@us.ibm.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       kvm-devel <kvm-devel@lists.sourceforge.net>
Subject: Re: [kvm-devel] kvm causing memory corruption?  ~2.6.25-rc6
References: <1206479576.7562.21.camel@nimitz.home.sr71.net>
In-Reply-To: <1206479576.7562.21.camel@nimitz.home.sr71.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0rc1 (firebolt.argo.co.il [0.0.0.0]); Wed, 26 Mar 2008 11:50:27 +0200 (IST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen wrote:
> I was getting some kvm userspace crashes trying to run a Windows guest.
> So, I decided to try a recent kernel (2.6.25-rc6-00333-ga4083c9)  with
> the kvm kernel code that shipped with that kernel.
>
>   

This is fixed in 2.6.25-rc7.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

