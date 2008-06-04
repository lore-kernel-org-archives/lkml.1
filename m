Return-Path: <linux-kernel-owner+w=401wt.eu-S1762385AbYFDTws@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762385AbYFDTws (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 15:52:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759481AbYFDTwK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 15:52:10 -0400
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:44542 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759334AbYFDTwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 15:52:00 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Y+JOJFjpcRnFZYNogVNawCGYN4sOTIivAKXh+DkuyKn6dgAOQQT9NkPGRcOEsMungUzCsCfA8MoBEqnO1MccKSEiViP/6xiWqmDx2vqkoHKAtAIUNwXtEkf3MiyMGYCuVv0zGjmnvS5gabza4FxmCi/w9709Xq+4r3Z0tuAjJmg=  ;
X-YMail-OSG: 7WPeRd0VM1kUCts9h7SrbjmdJxExSH.TVgcjCTgWw.rHTxdPqNN.iO5tyZNAV.k4dZ6JaJRlgw7rF176qFx8FAXtz5mAfsYWEHFXTAGjXpq9QMUvIqcVVfiodU8pFQfiBLM-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
Subject: Re: [PATCH] spi: two bug-fixes
Date: Wed, 4 Jun 2008 12:51:52 -0700
User-Agent: KMail/1.9.9
Cc: Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org
References: <Pine.LNX.4.64.0806041705430.32657@axis700.grange> <20080604153132.GB4189@cs181133002.pp.htv.fi> <Pine.LNX.4.64.0806041737550.32657@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0806041737550.32657@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806041251.52849.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 June 2008, Guennadi Liakhovetski wrote:
> 
> > The better fix of making "t" signed by Roel Kluin is already as
> > commit 1d1c1d9b557a12320174058d2d313ffb0f8611f4 in Linus' tree.
> 
> Good, thanks for letting know! David, please, let me know if you want me 
> to resubmit the second part of the patch separately, or if you can just 
> extract it from the original one.

Yes, please ... with updated patch comments.

