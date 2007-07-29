Return-Path: <linux-kernel-owner+w=401wt.eu-S1762799AbXG2Nod@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762799AbXG2Nod (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 09:44:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760927AbXG2NoY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 09:44:24 -0400
Received: from smtp-out2.blueyonder.co.uk ([195.188.213.5]:42641 "EHLO
	smtp-out2.blueyonder.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758752AbXG2NoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 09:44:24 -0400
From: Alistair John Strachan <alistair@devzero.co.uk>
To: Avi Kivity <avi@qumranet.com>
Subject: Re: 2.6.23-rc1, KVM-AMD problem
Date: Sun, 29 Jul 2007 14:44:17 +0100
User-Agent: KMail/1.9.7
Cc: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <200707281855.41277.alistair@devzero.co.uk> <200707291229.49155.alistair@devzero.co.uk> <46AC7B44.1040509@qumranet.com>
In-Reply-To: <46AC7B44.1040509@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707291444.18024.alistair@devzero.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 29 July 2007 12:34:28 you wrote:
[snip]
> > Doesn't help, I still get the same crashes. I tried 2.6.22 again and it's
> > rock solid by comparison.
>
> Do you mean, kvm-33 on top of 2.6.22, or the kvm modules from 2.6.22?
> Please describe your configuration *exactly*.

I'm using the kvm-33 *userspace* package (based on Debian's kvm-28 packaging) 
and 2.6.23-rc1's KVM modules. I patched 2.6.23-rc1 with the patch you 
provided in your last email. So I'm not using -git HEAD.

Maybe there's been additional necessary fixes to -git requiring me to update 
to HEAD? That wasn't clear from your last email.

> And what do you mean, "rock solid by comparison"?  Either it's rock
> solid or it isn't.

It's rock solid. It does not crash.

-- 
Cheers,
Alistair.

137/1 Warrender Park Road, Edinburgh, UK.

