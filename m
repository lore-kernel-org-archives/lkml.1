Return-Path: <linux-kernel-owner+w=401wt.eu-S1757498AbYDRGXX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757498AbYDRGXX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 02:23:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753179AbYDRGXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 02:23:13 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44218
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753140AbYDRGXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 02:23:12 -0400
Date: Thu, 17 Apr 2008 23:23:11 -0700 (PDT)
Message-Id: <20080417.232311.256794268.davem@davemloft.net>
To: jesper.juhl@gmail.com
Cc: paul.moore@hp.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][netlabel] Don't risk NULL ptr deref in
 netlbl_unlabel_staticlist_gen() if ifindex not found
From: David Miller <davem@davemloft.net>
In-Reply-To: <9a8748490804161430w3a9a9ed8o4dcc80d260a14500@mail.gmail.com>
References: <alpine.LNX.1.00.0804162304220.9837@dragon.funnycrock.com>
	<200804161721.33749.paul.moore@hp.com>
	<9a8748490804161430w3a9a9ed8o4dcc80d260a14500@mail.gmail.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Jesper Juhl" <jesper.juhl@gmail.com>
Date: Wed, 16 Apr 2008 23:30:10 +0200

> On 16/04/2008, Paul Moore <paul.moore@hp.com> wrote:
> >  Acked-by: Paul Moore <paul.moore@hp.com>
> >
> 
> David, will you merge this in the net tree ?

I've done that, thanks everyone.
