Return-Path: <linux-kernel-owner+w=401wt.eu-S1752634AbZIYVAz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752634AbZIYVAz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 17:00:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752442AbZIYVAy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 17:00:54 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:54170 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540AbZIYVAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 17:00:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Bg5uFMCxj2f4zYTU9UP5aesN53w4IKW0JVzxBiRXREUDMFEdiCSy1EHI9JCJGSFLk4
         +o7eeI1vuAG0gBURebRzBcNX4ThVpKAZ39U+32IwZNODlQ2k4chfjX+KxglNErMMQ2U4
         5QPSCEzn3FwsM/hHz8e7TH0ou3tJqE788VvcA=
Message-ID: <4ABD2F87.6040905@lwfinger.net>
Date: Fri, 25 Sep 2009 16:00:55 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Gary Hade <garyhade@us.ibm.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Len Brown <lenb@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: fixing "pci=use_crs"
References: <200909161715.24376.bjorn.helgaas@hp.com> <4AB95F41.1070500@lwfinger.net> <200909231723.31786.bjorn.helgaas@hp.com> <200909240926.47674.bjorn.helgaas@hp.com>
In-Reply-To: <200909240926.47674.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bjorn Helgaas wrote:
> On Wednesday 23 September 2009 05:23:30 pm Bjorn Helgaas wrote:
>> Would you mind trying the attached debug patch to try to confirm this?
> 
> Let me refine this patch a little before you try it out.  For
> one thing, it applies on top of a bunch of patches in my queue,
> so it won't apply directly for you.

This mail was on my computer before I had a chance to try to patch.
I'll await a revised one.

Larry
