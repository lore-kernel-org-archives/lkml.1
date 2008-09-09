Return-Path: <linux-kernel-owner+w=401wt.eu-S1757478AbYIISpz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757478AbYIISpz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 14:45:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755446AbYIISph
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 14:45:37 -0400
Received: from outbound-mail-03.bluehost.com ([69.89.21.13]:35507 "HELO
	outbound-mail-03.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755371AbYIISpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 14:45:36 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=EB/3UtVRdMNV7EJst2zy3E+hl7UBr0ELBWhYD6NnS5YwYeoo32MqdFwPWebFRc0oWV6ZaPd5daZ+iiWaIDVobiH4IJC0vYKsVPAu7T3vEVdnXi/rT/bedxD/RVaPlxZu;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [PATCH 1/6] pci: fix merging left out for BAR print out
Date: Tue, 9 Sep 2008 11:45:25 -0700
User-Agent: KMail/1.9.9
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <1220312246-30879-1-git-send-email-yhlu.kernel@gmail.com>
In-Reply-To: <1220312246-30879-1-git-send-email-yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809091145.26132.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 131.252.210.190 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, September 01, 2008 4:37 pm Yinghai Lu wrote:
> print out for Device BAR address before kernel try to update them.
>
> also change it to KERN_DEBUG instead...
>
> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

Can you resend this against my linux-next branch?  It didn't apply to my 
latest bits...

Thanks,
Jesse
