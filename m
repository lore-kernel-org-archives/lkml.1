Return-Path: <linux-kernel-owner+w=401wt.eu-S1754414AbZKQJf5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754414AbZKQJf5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 04:35:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753354AbZKQJf4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 04:35:56 -0500
Received: from bamako.nerim.net ([62.4.17.28]:49281 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753091AbZKQJfy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 04:35:54 -0500
Date: Tue, 17 Nov 2009 10:35:54 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Ben Hutchings <bhutchings@solarflare.com>,
       David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Mika Kuoppala <mika.kuoppala@nokia.com>,
       Linux I2C <linux-i2c@vger.kernel.org>
Subject: Re: Shared i2c adapter locking
Message-ID: <20091117103554.03971b2f@hyperion.delvare>
In-Reply-To: <20091117193313.b750804e.sfr@canb.auug.org.au>
References: <20091026133757.7cf87e49.sfr@canb.auug.org.au>
	<20091029154317.651904b9@hyperion.delvare>
	<1256828976.2827.27.camel@achroite>
	<20091105141122.56b6b4f8@hyperion.delvare>
	<1257429444.2793.2.camel@achroite.uk.solarflarecom.com>
	<20091105150715.692b5200@hyperion.delvare>
	<20091117193313.b750804e.sfr@canb.auug.org.au>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Tue, 17 Nov 2009 19:33:13 +1100, Stephen Rothwell wrote:
> Hi Jean,
> 
> On Thu, 5 Nov 2009 15:07:15 +0100 Jean Delvare <khali@linux-fr.org> wrote:
> >
> > > Presumably this is meant for net-next-2.6, and you'll implement
> > 
> > Actually I meant to push this to Linus immediately, through my i2c
> > tree. This is essentially a no-op: the binary code will be the same as
> > before the patch, so guaranteed to be safe, and this will solve
> > conflicts in linux-next.
> 
> Any word on this?

Haven't you read this:
http://www.spinics.net/lists/linux-next/msg07839.html

and the 3 following posts?

If you did and something is still not clear, please let me know. My
understanding is that the action token is in David's hands now.

-- 
Jean Delvare
