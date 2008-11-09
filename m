Return-Path: <linux-kernel-owner+w=401wt.eu-S1755393AbYKINAP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393AbYKINAP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 08:00:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754753AbYKIM76
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 07:59:58 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:19786 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755283AbYKIM74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 07:59:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=g3juB16HWzBl2QBnZ0BVH2nx4ImgjTAsvQf2Ncws+UN/n/sQcLbR5nkJIb9aAhIUsg
         ykx76tYaMAJhE9TSns4vAYAzAHPz8tflK3OQn1v7g+ef1SpYVlv4GUNBTzyxzD4SfS3x
         wYpSRWlbarN3VR/66FxlAWh3yZJSlyBlnO5CI=
Date: Sun, 9 Nov 2008 15:59:53 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Yinghai Lu <yhlu.kernel@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] x86: apic - use pr_ macros for logging
Message-ID: <20081109125953.GB551@localhost>
References: <20081109105709.222708517@gmail.com>> <4916c290.0c07560a.4a14.ffffdde9@mx.google.com> <alpine.LFD.1.10.0811091239360.25325@ftp.linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0811091239360.25325@ftp.linux-mips.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Maciej W. Rozycki - Sun, Nov 09, 2008 at 12:44:54PM +0000]
| On Thu, 1 Jan 1970, Cyrill Gorcunov wrote:
| 
| > Impact: cleanup
| > 
| > It saves us some sourcse lines and shift
| > the code a bit righter.
| > 
| > And a multiline comment style is fixed too :-)
| > 
| > Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
| > ---
| >  arch/x86/kernel/apic.c |  116 ++++++++++++++++++++++---------------------------
| >  1 file changed, 53 insertions(+), 63 deletions(-)
| 
| Acked-by: Maciej W. Rozycki <macro@linux-mips.org>
| 
|  Thanks, Cyrill -- it was high time to get this done.  And, BTW, at the 
| next opportunity please fix up your date -- I think it may confuse some 
| people and/or scripts.  Good to know it was a Thursday though. ;)
| 
|   Maciej
|

Thanks for review, Maciej! I really sorry for that "date" related
issue -- will debug it and try to eliminate in future.
 
		- Cyrill -
