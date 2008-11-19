Return-Path: <linux-kernel-owner+w=401wt.eu-S1753103AbYKSWMx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753103AbYKSWMx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 17:12:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751408AbYKSWMo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 17:12:44 -0500
Received: from smtp128.sbc.mail.sp1.yahoo.com ([69.147.65.187]:41946 "HELO
	smtp128.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751328AbYKSWMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 17:12:43 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:Reply-To:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=CrrJwRYdf6hyWfnL6cgjTILE4sSP/vkMDKCF8m8n7vSPYIWIx3+7fTTy7kKZa9aZkWTaqU/val7To8InZVVTYbfEmeyPV5ncUnKJrbHvCLmXygMFuwTMk3Hs5FtBwEbc4fTzjVdJBI2OkxlGgXajL5g+Bz39EW6frXEzRw2miFo=  ;
X-YMail-OSG: HJxt3qgVM1m7ELajl.IB4DbWnzSKS318oCUbArZQXkcVqTKiRAjkB6NwF40dmwaPTbT6QVZW9L24TFyhdyMDzOWqCz540NDNOq6Xn3SNWazZQveqKDRfPlTMuifZdf0VV2XAW3ytX7dusbUD7dOOqBKj
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
Reply-To: dbrownell@users.sourceforge.net
To: Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [patch 2.6.28-rc5] regulator: enable/disable refcounting
Date: Wed, 19 Nov 2008 14:12:40 -0800
User-Agent: KMail/1.9.10
Cc: lkml <linux-kernel@vger.kernel.org>, Mark Brown <broonie@sirena.org.uk>
References: <200811161144.46582.david-b@pacbell.net> <1227129996.585.22.camel@vega.slimlogic.co.uk>
In-Reply-To: <1227129996.585.22.camel@vega.slimlogic.co.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811191412.41259.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 19 November 2008, Liam Girdwood wrote:
> Both -rc5 patches applied.

How about the other two which seemed non-controversial?

  http://marc.info/?l=linux-kernel&m=122645403604873&w=2 (code shrink)
  http://marc.info/?l=linux-kernel&m=122645416305013&w=2 (attribute shrink)

Those were sent against RC4.

- Dave

