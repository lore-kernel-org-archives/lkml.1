Return-Path: <linux-kernel-owner+w=401wt.eu-S1757504AbZKDRWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757504AbZKDRWS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 12:22:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757392AbZKDRWR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 12:22:17 -0500
Received: from outbound-mail-146.bluehost.com ([67.222.38.36]:36160 "HELO
	outbound-mail-146.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757293AbZKDRWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 12:22:16 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=oqueTmX8Wxr4+2oPmmJHJQnSnQpIcRPqQYdc+CL4faQ6pfu5MvP9/H5LgNPYr61M52owpebGLo/XflyWxxrJKvWwS6PPG4Cx5uV1qxZP04oUA+4GKZJiv83VxOZoBxaJ;
Date: Wed, 4 Nov 2009 09:22:19 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Brad Spengler <spender@grsecurity.net>, Matthew Wilcox <matthew@wil.cx>,
       Yinghai Lu <yinghai@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>
Subject: Re: [PATCH] ia64: Don't call SAL < 3.2 for extended config space
Message-ID: <20091104092219.228a5186@jbarnes-piketon>
In-Reply-To: <57C9024A16AD2D4C97DC78E552063EA3E36222B3@orsmsx505.amr.corp.intel.com>
References: <20091011074531.GA12357@grsecurity.net>
	<4AD1AE0D.1030007@kernel.org>
	<4AD24766.7050205@kernel.org>
	<20091011213245.GC18513@grsecurity.net>
	<20091011231039.GB7545@parisc-linux.org>
	<20091012135628.GA310@grsecurity.net>
	<20091012142430.GE7545@parisc-linux.org>
	<20091013045808.GB9782@grsecurity.net>
	<20091104091608.7b813549@jbarnes-piketon>
	<57C9024A16AD2D4C97DC78E552063EA3E36222B3@orsmsx505.amr.corp.intel.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Nov 2009 09:20:13 -0800
"Luck, Tony" <tony.luck@intel.com> wrote:

> > I've dropped the ball on this one though; maybe Tony already picked
> > it up?  Tony?
> 
> Yes.  It went in to Linus' tree with the git pull I sent on Monday
> (just prior to -rc6).
> 
> Commit: adcd74034 ...

Great, thanks for confirming.

-- 
Jesse Barnes, Intel Open Source Technology Center
