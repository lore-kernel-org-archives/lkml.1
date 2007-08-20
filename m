Return-Path: <linux-kernel-owner+w=401wt.eu-S1761232AbXHTQE0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761232AbXHTQE0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 12:04:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761265AbXHTQDH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 12:03:07 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39468 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760891AbXHTQDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 12:03:04 -0400
Date: Mon, 20 Aug 2007 09:02:27 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: James Corey <ploversegg@yahoo.com>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org, Netdev <netdev@vger.kernel.org>
Subject: Re: 2.6.23-rc3 and SKY2 driver issue
Message-ID: <20070820090227.6ceb2934@freepuppy.rosehill.hemminger.net>
In-Reply-To: <370212.9287.qm@web90407.mail.mud.yahoo.com>
References: <20070816090556.6a5295e6@oldman>
	<370212.9287.qm@web90407.mail.mud.yahoo.com>
Organization: Linux Foundation
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Aug 2007 08:42:21 -0700 (PDT)
James Corey <ploversegg@yahoo.com> wrote:

> 
> --- Stephen Hemminger
> <shemminger@linux-foundation.org> wrote:
> 
> > On Thu, 16 Aug 2007 10:25:45 +0200
> > "Michal Piotrowski"
>
> > Please reproduce with a more recent kernel?
> 
> Um, I thought 2.6.23rc WAS pretty recent. :-)
> 
> I'll check if there is something newer in the
> repository now.
> 

What is the chip version?  Please send console log: "dmesg | grep sky2"


-- 
Stephen Hemminger <shemminger@linux-foundation.org>
