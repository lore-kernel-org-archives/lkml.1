Return-Path: <linux-kernel-owner+w=401wt.eu-S1755719AbZFOKSF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755719AbZFOKSF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 06:18:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753542AbZFOKRx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 06:17:53 -0400
Received: from adelie.canonical.com ([91.189.90.139]:45930 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753021AbZFOKRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 06:17:52 -0400
Date: Mon, 15 Jun 2009 11:17:53 +0100
From: Andy Whitcroft <apw@canonical.com>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: "sky2: set VPD size" triggers card recognition failure
Message-ID: <20090615101753.GB13761@shadowen.org>
References: <20090611122942.GA7554@shadowen.org> <20090611100347.7c4160a4@nehalam> <20090612115120.GA13960@shadowen.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090612115120.GA13960@shadowen.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 12, 2009 at 12:51:20PM +0100, Andy Whitcroft wrote:
> On Thu, Jun 11, 2009 at 10:03:47AM -0700, Stephen Hemminger wrote:
> 
> > Some of the chip version have different registers, and some hardware vendors build
> > boards without VPD.  Does this help:
> 
> Thanks for the patch.  I have built some kernels and pushed them out
> for testing.  Will let you know what comes of it!

Ok, that tests out good as well.

Tested-by: Andy Whitcroft <apw@canonical.com>

-apw
