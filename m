Return-Path: <linux-kernel-owner+w=401wt.eu-S1752728AbZIIJXd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728AbZIIJXd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 05:23:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751979AbZIIJXc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 05:23:32 -0400
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:42087 "EHLO
	electric-eye.fr.zoreil.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751779AbZIIJXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 05:23:31 -0400
Date: Wed, 9 Sep 2009 11:28:22 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Alex Bennee <kernel-hacker@bennee.com>
Cc: lkml <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Subject: Re: r8169 ethernet hangs after a pm-suspend (and resume)
Message-ID: <20090909092822.GA18355@electric-eye.fr.zoreil.com>
References: <b2cdc9f30909090013q1741da26la73da66f1eef975f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b2cdc9f30909090013q1741da26la73da66f1eef975f@mail.gmail.com>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Bennee <kernel-hacker@bennee.com> :
[...]
> I've just recently gotten suspend working on my system. Unfortunately
> after the resume event I loose access to the network.
> As far as the system is concerned the network is configured properly
> but every attempt to ping local nodes fails with "Host not reachable".

Can the problem be described as "gigabit link setting does not survive
suspend/resume" ?

-- 
Ueimor
