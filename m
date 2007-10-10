Return-Path: <linux-kernel-owner+w=401wt.eu-S1757176AbXJJVPa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757176AbXJJVPa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 17:15:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754046AbXJJVPW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 17:15:22 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:58648 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753785AbXJJVPV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 17:15:21 -0400
Message-ID: <392050922.22220@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Thu, 11 Oct 2007 05:15:17 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Zachary Amsden <zach@vmware.com>
Cc: Avi Kivity <avi@argo.co.il>, lkml <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>, david-g@263.net
Subject: Re: x86_64 : kernel initial decompression hangs on vmware
Message-ID: <20071010211517.GA11612@mail.ustc.edu.cn>
References: <20071010073739.GA5952@mail.ustc.edu.cn> <1192043790.7073.61.camel@bodhitayantram.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1192043790.7073.61.camel@bodhitayantram.eng.vmware.com>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 10, 2007 at 12:16:30PM -0700, Zachary Amsden wrote:
> On Wed, 2007-10-10 at 15:37 +0800, Fengguang Wu wrote:
> > Hi Zachary,
> > 
> > One of my friends' vmware "hangs" on booting Linux 2.6.23, and then get
> > it to work by applying your patch at http://lkml.org/lkml/2007/8/4/72.
> > 
> > It would be nice to see your fix going into mainline :-)
> 
> I thought that patch already went into mainline in 2.6.23?  If not, it

Sorry, the problematic kernel was 2.6.22.

> would be nice to queue it for -stable (also for 2.6.22).

Agreed.

