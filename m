Return-Path: <linux-kernel-owner+w=401wt.eu-S1753802AbYCTEwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753802AbYCTEwU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 00:52:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751500AbYCTEwI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 00:52:08 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:22823 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363AbYCTEwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 00:52:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=MEmfzsbrjatnX5G57pe9f9rERqi+3svksAHDVazH4aFAfCUFl+Yp43vn0GKkPPJR3LAZYqkZsipYDtuWP3MKW+KF6zVneGsl0mmX3MMlSjbeEMZUsQpVncw+EuQvNZwgECdTbdgJHgonNwkvz2ZxNpkqTUrUWMDg2j88YrRZTxY=
Message-ID: <2f11576a0803192151i2e598656iaf3fd0c7e5a165f4@mail.gmail.com>
Date: Thu, 20 Mar 2008 13:51:57 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: "Luming Yu" <luming.yu@gmail.com>
Subject: Re: [2.6.25-rc5-mm1][regression] ia64: hackbench doesn't finish >12 hour
Cc: "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Yu, Fenghua" <fenghua.yu@intel.com>,
       "Luck, Tony" <tony.luck@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-ia64@vger.kernel.org,
       "Hidetoshi Seto" <seto.hidetoshi@jp.fujitsu.com>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <3877989d0803192039n6b1a2631y5c593f1508a0b328@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080318084314.FF0F.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <DDF46CB71CB9D647A983FECACF09A886A33019@orsmsx424.amr.corp.intel.com>
	 <20080318094527.FF12.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <DDF46CB71CB9D647A983FECACF09A886A8A6B5@orsmsx424.amr.corp.intel.com>
	 <1205969039.6437.44.camel@lappy>
	 <3877989d0803192039n6b1a2631y5c593f1508a0b328@mail.gmail.com>
X-Google-Sender-Auth: c6c936fa5f49fcaf
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> >  Hmm, then again, does ia64 have lockdep?
>  I posted an initial version of lockdep support for ia64 here.
>  http://www.gelato.unsw.edu.au/archives/linux-ia64/0712/21510.html
>  Time is still needed to make it upstream though..

That is very nice work.
please rebase to latest kernel.
I advocate your activity :)
