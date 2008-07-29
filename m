Return-Path: <linux-kernel-owner+w=401wt.eu-S1754744AbYG2BZy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744AbYG2BZy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 21:25:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754280AbYG2BZm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 21:25:42 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:30894 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754205AbYG2BZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 21:25:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=YCbDjghkxEi7QEzeYYuWLmXgVEppZhDy/6pcXLpU5xVivEjTB5Uvl+0nN7xZYToPDe
         SaImlPTT32dPA1kPVLW4l/zhXpcvJUTmfKWugII5rPmaGKSuKkGThRkTroVavmmE8UC7
         JdVcJVBQtPCq+aTNwptnS+rlrytKOTn3R2Tus=
Message-ID: <9e4733910807281825v42f9700al420ba48aebf3d790@mail.gmail.com>
Date: Mon, 28 Jul 2008 21:25:39 -0400
From: "Jon Smirl" <jonsmirl@gmail.com>
To: "Al Viro" <viro@zeniv.linux.org.uk>
Subject: Re: 463 kernel developers missing!
Cc: "Simon Arlott" <simon@fire.lp0.eu>, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20080729011526.GF28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9e4733910807280745l248801ebp134e77fc1ac70c02@mail.gmail.com>
	 <488DF9CF.8020408@simon.arlott.org.uk>
	 <9e4733910807281005y62dca90ar96f663908e644546@mail.gmail.com>
	 <488DFD97.7080802@simon.arlott.org.uk>
	 <9e4733910807281022v38d323c9sc7b63235824690f6@mail.gmail.com>
	 <488E0BB6.7020006@simon.arlott.org.uk>
	 <9e4733910807281119m10f9b6e3v98fc892a42476c86@mail.gmail.com>
	 <488E1147.5040803@simon.arlott.org.uk>
	 <9e4733910807281200m25f7f16bwa6678694bb25a61@mail.gmail.com>
	 <20080729011526.GF28946@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/28/08, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Mon, Jul 28, 2008 at 03:00:13PM -0400, Jon Smirl wrote:
>
>
> > Other people aren't perfect, I've found over 1,000 typos in the those
>  > names and emails. We need a validation mechanism.
>
> Who's "we", luser, and why would I possibly give a damn for your needs?

Let's drop the whole Sign-off-by mechanism. If we can't be bothered to
clean up the junk in Signed-off-by why should we bother recording
them? Sign every patch Mickey Mouse, it has the same effect.

-- 
Jon Smirl
jonsmirl@gmail.com
