Return-Path: <linux-kernel-owner+w=401wt.eu-S1756481AbZFPJ01@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756481AbZFPJ01 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 05:26:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751831AbZFPJ0S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 05:26:18 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39211
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750961AbZFPJ0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 05:26:17 -0400
Date: Tue, 16 Jun 2009 02:26:20 -0700 (PDT)
Message-Id: <20090616.022620.61989153.davem@davemloft.net>
To: apw@canonical.com
Cc: shemminger@vyatta.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: "sky2: set VPD size" triggers card recognition failure
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090615101753.GB13761@shadowen.org>
References: <20090611100347.7c4160a4@nehalam>
	<20090612115120.GA13960@shadowen.org>
	<20090615101753.GB13761@shadowen.org>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Whitcroft <apw@canonical.com>
Date: Mon, 15 Jun 2009 11:17:53 +0100

> On Fri, Jun 12, 2009 at 12:51:20PM +0100, Andy Whitcroft wrote:
>> On Thu, Jun 11, 2009 at 10:03:47AM -0700, Stephen Hemminger wrote:
>> 
>> > Some of the chip version have different registers, and some hardware vendors build
>> > boards without VPD.  Does this help:
>> 
>> Thanks for the patch.  I have built some kernels and pushed them out
>> for testing.  Will let you know what comes of it!
> 
> Ok, that tests out good as well.
> 
> Tested-by: Andy Whitcroft <apw@canonical.com>

Applied, thanks everyone.
