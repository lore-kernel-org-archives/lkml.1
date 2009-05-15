Return-Path: <linux-kernel-owner+w=401wt.eu-S1760318AbZEOIwm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760318AbZEOIwm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 04:52:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755475AbZEOIwd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 04:52:33 -0400
Received: from smtp126.sbc.mail.sp1.yahoo.com ([69.147.65.185]:25511 "HELO
	smtp126.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755097AbZEOIwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 04:52:33 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=5glCwZCN9t/YhpZsGc39CNKl2jBKNiGTBL3Uq4+wjwcOYV05+IfJ428UR85XRVCFx2QoCMICTaQu+RjRP793liX6pj5AOMU5AmZO8gigxr3zWU1kk5icOGncA8NP7T/BRw5/FrPmdh+LWAItrFH8t7zNzUWY6iKH6jkkkc0q/U4=  ;
X-YMail-OSG: V5DPO_sVM1lV4otHx68B1Y3KeVoAmiFfeyKj6So4VHG9kW8bRxws8KwGU7ZWqRcqhHybRFPzw7cF9tbPSzP8oHFLEvVl9Ws_2TS3FDohy20NECwetoX9zm08SI9wqij.YunYdd7yg.UGhx7ov3z8_q1PY30aHDjHKUjl956H8brK_twtvr0O9fP3AiVzMsq56JxAj1UI.5kHzK9ACU8lHcsFq3dSbg10VeYhwWk_6oKGd0NOhI1BlZ25wMzx6PTkcXi7RwOpPZMiysg-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [patch 0/3] DaVinci ASoC updates
Date: Fri, 15 May 2009 01:52:32 -0700
User-Agent: KMail/1.9.10
Cc: lrg@slimlogic.co.uk, lkml <linux-kernel@vger.kernel.org>,
       DaVinci <davinci-linux-open-source@linux.davincidsp.com>
References: <200905141235.35600.david-b@pacbell.net> <20090515081917.GA29556@rakim.wolfsonmicro.main>
In-Reply-To: <20090515081917.GA29556@rakim.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905150152.33171.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 15 May 2009, Mark Brown wrote:
> On Thu, May 14, 2009 at 12:35:35PM -0700, David Brownell wrote:
> 
> > The 2.6.30-rc5 merges included a bunch of DaVinci platform
> > updates, including EDMA support.  Which means that finally
> > the ASoC stuff can be made to build in mainline ... it was
> > probably sent to mainline before its time.  ;)
> 
> I've applied all three patches.

Thanks.


> Obviously they should all have been 
> merged much earlier but given that the code didn't even build there's
> no risk of making the situation worse and they look fine.

Yeah; I'm glad those updates managed to get into RC5.
Until they did, there wasn't much point in sending what
would likely have been an incomplete synch.
