Return-Path: <linux-kernel-owner+w=401wt.eu-S1752905AbYCLKNo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905AbYCLKNo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 06:13:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751468AbYCLKNg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 06:13:36 -0400
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:32590 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751464AbYCLKNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 06:13:35 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=dVNTCMjjwgjar0YQE0vCc3WDHiyJyWex8xn8rb6agKU4gmflKIM0x1gHdkaG6q/4s2jFVr2BUBQ298fLKYFQu16UcS3beagif71AoAAT8ZMbKx3+SCMAN9HLGKPO03Lp3J18GJtBdiAMSxX4A7fUjhrkdZ2LWzeU4Kr+MShkBjc=  ;
X-YMail-OSG: 7V8bVS0VM1nA7DUUr5XBFGifeWPNosyo9qmX5zqeCU5uMVD5Fi22fWmGVNdoa1rSs_RJyEH6eA--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Lennert Buytenhek <buytenh@wantstofly.org>
Subject: Re: ehci watchdog-related splatter in 2.6.25-rc4
Date: Wed, 12 Mar 2008 02:13:23 -0800
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, Chris Wedgwood <cw@f00f.org>,
       Rabeeh Khoury <rabeeh@marvell.com>
References: <20080312093045.GA24017@xi.wantstofly.org> <200803120238.49050.david-b@pacbell.net> <20080312101131.GC24017@xi.wantstofly.org>
In-Reply-To: <20080312101131.GC24017@xi.wantstofly.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803120313.23568.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 March 2008, Lennert Buytenhek wrote:
> 
> > Does RC5 resolve this?
> 
> Nope.
> 
> e82cc1288fa57857c6af8c57f3d07096d4bcd9d9 (post -rc5) looks like it
> might fix it -- I'll re-test with that applied as well.

Sorry, I forgot that made it just *after* RC5.  That's the patch
I was interested in.

- Dave

