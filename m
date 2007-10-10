Return-Path: <linux-kernel-owner+w=401wt.eu-S1756107AbXJJSRI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756107AbXJJSRI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 14:17:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752400AbXJJSQ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 14:16:56 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:60664 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751740AbXJJSQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 14:16:56 -0400
Subject: Re: x86_64 : kernel initial decompression hangs on vmware
From: Zachary Amsden <zach@vmware.com>
To: Fengguang Wu <wfg@mail.ustc.edu.cn>
Cc: Avi Kivity <avi@argo.co.il>, lkml <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>, david-g@263.net
In-Reply-To: <20071010073739.GA5952@mail.ustc.edu.cn>
References: <20071010073739.GA5952@mail.ustc.edu.cn>
Content-Type: text/plain
Date: Wed, 10 Oct 2007 12:16:30 -0700
Message-Id: <1192043790.7073.61.camel@bodhitayantram.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-10-10 at 15:37 +0800, Fengguang Wu wrote:
> Hi Zachary,
> 
> One of my friends' vmware "hangs" on booting Linux 2.6.23, and then get
> it to work by applying your patch at http://lkml.org/lkml/2007/8/4/72.
> 
> It would be nice to see your fix going into mainline :-)

I thought that patch already went into mainline in 2.6.23?  If not, it
would be nice to queue it for -stable (also for 2.6.22).

Zach

