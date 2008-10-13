Return-Path: <linux-kernel-owner+w=401wt.eu-S1759315AbYJMOxc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759315AbYJMOxc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 10:53:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755858AbYJMOxV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 10:53:21 -0400
Received: from khc.piap.pl ([195.187.100.11]:43828 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756166AbYJMOxU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 10:53:20 -0400
To: Adrian Bunk <bunk@kernel.org>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Please pull - generic HDLC
References: <m33aj15xhr.fsf@maximus.localdomain>
	<20081012.144704.39192150.davem@davemloft.net>
	<20081013055356.GA29938@cs181140183.pp.htv.fi>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Mon, 13 Oct 2008 16:53:17 +0200
In-Reply-To: <20081013055356.GA29938@cs181140183.pp.htv.fi> (Adrian Bunk's message of "Mon\, 13 Oct 2008 08\:53\:56 +0300")
Message-ID: <m31vyk4kde.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk <bunk@kernel.org> writes:

> The over 3 weeks old -next already contains mostly the same as the HDLC 
> tree contains now.
>
> The thing you two should sort out is why the tree ended up as an own 
> tree in -next instead of pull requests to David long ago.
>
> E.g. the netdev and wireless trees also don't go into -next, but instead 
> with frequent pull requests to David.

I can't see any problem with this, is there any?

I want the HDLC tree tested in next before it's merged upstream
(= David's tree(s)). I don't want to push crap upstream  first and
only then try to fix it (though a bug still slips in sometimes).
-- 
Krzysztof Halasa
