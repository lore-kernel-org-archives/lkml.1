Return-Path: <linux-kernel-owner+w=401wt.eu-S1764907AbXJZSia@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764907AbXJZSia (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 14:38:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761011AbXJZSiK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 14:38:10 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42803 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760257AbXJZSiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 14:38:09 -0400
Date: Fri, 26 Oct 2007 19:37:40 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PCMCIA: prevent auto insert during resume.
Message-ID: <20071026183740.GF4321@flint.arm.linux.org.uk>
Mail-Followup-To: Rodolfo Giometti <giometti@enneenne.com>,
	linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20071026105125.GA28769@enneenne.com> <20071026151141.GA4321@flint.arm.linux.org.uk> <20071026154705.GY19019@enneenne.com> <20071026160206.GC4321@flint.arm.linux.org.uk> <20071026162705.GZ19019@enneenne.com> <20071026163651.GD4321@flint.arm.linux.org.uk> <20071026165400.GA19019@enneenne.com> <20071026170030.GE4321@flint.arm.linux.org.uk> <20071026171857.GC19019@enneenne.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071026171857.GC19019@enneenne.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2007 at 07:18:57PM +0200, Rodolfo Giometti wrote:
> On Fri, Oct 26, 2007 at 06:00:31PM +0100, Russell King wrote:
> > Or that - probably a sysfs attribute on the pcmcia socket would be
> > better.
> 
> Ok, but how can I do it? Can you please suggest to me the name of such
> attribute and where should I add it into the PCMCIA code? Also, which
> should be the default dehaviour? ;)

My consulting rates are...  Seriously, if you want me to write a patch
for you, you have to pay for that.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
