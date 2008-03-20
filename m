Return-Path: <linux-kernel-owner+w=401wt.eu-S1755650AbYCTDk5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755650AbYCTDk5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 23:40:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753294AbYCTDkI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 23:40:08 -0400
Received: from rv-out-0910.google.com ([209.85.198.184]:27080 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752835AbYCTDkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 23:40:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=azCZG3RzbLycEElrxV2UZi1AlmkjaTC5yLottGyy82Z4JZcC0dE24omzIO+NSE2JVlkR7pBAM+8ZKNlCMD3eCOCwshjC10QhNOGrFzIxDCtNgXQNgI9+1bG0uv+Q7yDrgMzVbm0P0Ay5jfRIKiVuTqBL29b7yC8TKkirQteUxA8=
Message-ID: <3877989d0803192039n6b1a2631y5c593f1508a0b328@mail.gmail.com>
Date: Thu, 20 Mar 2008 11:39:55 +0800
From: "Luming Yu" <luming.yu@gmail.com>
To: "Peter Zijlstra" <a.p.zijlstra@chello.nl>
Subject: Re: [2.6.25-rc5-mm1][regression] ia64: hackbench doesn't finish >12 hour
Cc: "Yu, Fenghua" <fenghua.yu@intel.com>,
       "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>,
       "Luck, Tony" <tony.luck@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-ia64@vger.kernel.org,
       "Hidetoshi Seto" <seto.hidetoshi@jp.fujitsu.com>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <1205969039.6437.44.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080318084314.FF0F.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <DDF46CB71CB9D647A983FECACF09A886A33019@orsmsx424.amr.corp.intel.com>
	 <20080318094527.FF12.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <DDF46CB71CB9D647A983FECACF09A886A8A6B5@orsmsx424.amr.corp.intel.com>
	 <1205969039.6437.44.camel@lappy>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  Hmm, then again, does ia64 have lockdep?
I posted an initial version of lockdep support for ia64 here.
http://www.gelato.unsw.edu.au/archives/linux-ia64/0712/21510.html
Time is still needed to make it upstream though..
