Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752093Ab0BMHbT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 02:31:19 -0500
Received: from poutre.nerim.net ([62.4.16.124]:53304 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751924Ab0BMHbS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 02:31:18 -0500
Date: Sat, 13 Feb 2010 08:31:15 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Phillip Lougher <phillip@lougher.demon.co.uk>
Cc: "FTPAdmin Kernel.org" <ftpadmin@kernel.org>, users@kernel.org,
       lasse.collin@tukaani.org, mirrors@kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [kernel.org users] XZ Migration discussion
Message-ID: <20100213083115.5cf8d4a4@hyperion.delvare>
In-Reply-To: <4B75E6C7.5030106@lougher.demon.co.uk>
References: <4B744E13.8040004@kernel.org>
	<20100212150137.648dca7c@hyperion.delvare>
	<4B75A5CF.70308@lougher.demon.co.uk>
	<20100212203209.0cb8afc3@hyperion.delvare>
	<4B75B2A6.5080006@lougher.demon.co.uk>
	<20100212225923.36a67112@hyperion.delvare>
	<4B75E6C7.5030106@lougher.demon.co.uk>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Feb 2010 23:39:51 +0000, Phillip Lougher wrote:
> Jean Delvare wrote:
> > Prove it. Many people out there are still working on older trees. I am
> > working on 2.6.5 and 2.6.16 kernels on a weekly basis. If ketchup or
> > other tools break for these trees only and not more recent ones, that
> > won't help me at all, I will still have to update them.
> 
> Why are you still working on 2.6.5 and 2.6.16 kernels on a weekly
> basis?

Because I am doing support for enterprise customers who are using
distributions based on these kernel versions. These are SLE 9 and SLE
10, to name them, but RHEL supporters are in the same situation. And
I've heard embedded developers report many times that they had to stick
to older 2.6.x kernels too for various reasons. Not everyone is using a
recent 2.6.x kernel, which makes it hard to draw a line between what
should be considered old ones and what should be considered new ones.

-- 
Jean Delvare
"It is not necessary to hope in order to undertake, nor to succeed in
order to persevere" -- Charles The Bold
