Return-Path: <linux-kernel-owner+w=401wt.eu-S1753374AbYI2RFx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374AbYI2RFx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 13:05:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751590AbYI2RFp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 13:05:45 -0400
Received: from outbound-mail-31.bluehost.com ([69.89.18.151]:36807 "HELO
	outbound-mail-31.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751355AbYI2RFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 13:05:44 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=a0A0q2Cj7d6Cwq9ZKgjRC3iRYOlzKcotlFKJBmpW81a2oa8d226HQmj7nbpIrGH/T97ABGm4rDRBWZt3hlyKRLTtRd9uFaZGgGwhqGnuoLDopK8N9FvBFTGA83c+q4im;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: [PATCH 7/7] x86: print out irq nr for msi/ht -v2
Date: Mon, 29 Sep 2008 10:05:02 -0700
User-Agent: KMail/1.9.9
Cc: Ingo Molnar <mingo@elte.hu>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Yinghai Lu <yinghai@kernel.org>, Len Brown <lenb@kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org
References: <1222323223-23529-1-git-send-email-yhlu.kernel@gmail.com> <20080927185306.GA18619@elte.hu> <20080927190237.GD10186@localhost>
In-Reply-To: <20080927190237.GD10186@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809291005.04941.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, September 27, 2008 12:02 pm Cyrill Gorcunov wrote:
> [Ingo Molnar - Sat, Sep 27, 2008 at 08:53:06PM +0200]
>
> ...
>
> A bit offtopic...well...completely offtopic I would say :)
>
> Ingo maybe you have any PCI specs? I've asked several people
> for this. Peter adviced to ask HW vendors but I don't have
> friends who has access to a such docs. Evgeniy Polyakov
> promised to ask someone but I think there will not be success
> too :(. I'll ask Maciej too later since now he seems to be
> quite busy.

I think if you use google you can find the PCI spec in pdf form (search for 
pci pdf probably).  The MindShare books are also quite good, and cover PCI, 
PCI-X, and PCI Express in great detail (far more readable than the spec too).

-- 
Jesse Barnes, Intel Open Source Technology Center
