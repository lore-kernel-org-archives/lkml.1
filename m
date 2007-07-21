Return-Path: <linux-kernel-owner+w=401wt.eu-S933106AbXGUVre@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933106AbXGUVre (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 17:47:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762421AbXGUVrZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 17:47:25 -0400
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:34077 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1762307AbXGUVrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 17:47:24 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=IYqp0E3SFkJMeDZhOX3qA9O4x35Ik2Rfg2Q10sqcj8alLekC2PPkU/YfjNXdMAMcyPtHm74+75hD8F/FGip3T9Up5B11vWmvJi3vjgkB8u1rhMi5CxCju/BA1f+JVwyns3UfA40+Y1SDzNTnA91l+oYH7feAqd6NVRvlLIK4V7o=  ;
X-YMail-OSG: STjapQYVM1kPWHfRHgQM3X1hQxsGkNWs0cSuhRCqawgl9Sn.0eMHgW9jHEJdLm9a8gNCCiwKig--
From: David Brownell <david-b@pacbell.net>
To: linux-usb-devel@lists.sourceforge.net
Subject: Re: [linux-usb-devel] PXA27x UDC driver GIT repository
Date: Sat, 21 Jul 2007 14:47:22 -0700
User-Agent: KMail/1.9.6
Cc: Rodolfo Giometti <giometti@enneenne.com>, linux-kernel@vger.kernel.org
References: <20070721130256.GA22671@enneenne.com>
In-Reply-To: <20070721130256.GA22671@enneenne.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707211447.22364.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 21 July 2007, Rodolfo Giometti wrote:
> I reworked the driver according to latest suggestions from you.

... except for the most important one, which is to remove the
requirement to change every part of the gadget driver stack to
work around quirks in that particular hardware!!

I hope patches to resolve that issue get contributed soonish.

