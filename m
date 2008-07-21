Return-Path: <linux-kernel-owner+w=401wt.eu-S1758105AbYGUBq4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758105AbYGUBq4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 21:46:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756573AbYGUBqt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 21:46:49 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:65346 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756547AbYGUBqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 21:46:49 -0400
Subject: Re: [patch 0/4] Second batch of fastboot patches: get rid of the 2
	second rootfs delay
From: Daniel Walker <dwalker@mvista.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu,
       Simon Arlott <simon@fire.lp0.eu>,
       Rene Herman <rene.herman@keyaccess.nl>
In-Reply-To: <20080720151436.26bdc717@infradead.org>
References: <20080720151436.26bdc717@infradead.org>
Content-Type: text/plain
Date: Sun, 20 Jul 2008 18:46:45 -0700
Message-Id: <1216604805.14562.7.camel@dhcp32.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-07-20 at 15:14 -0700, Arjan van de Ven wrote:
> Hi,
> 
> this second batch of fastboot patches gets rid of the delay you can get
> when you're not using an initrd; on my system this delay is a full 2
> seconds (which is longer than the whole kernel boot combined).
> 
> I've also stuck the patch series into a git tree
> 
> clone git://git.kernel.org/pub/scm/linux/git/arjan/linux-2.6-fastboot
> 

Typo in the URL above, I think it's

git://git.kernel.org/pub/scm/linux/kernel/git/arjan/linux-2.6-fastboot
				   ^^^^^^
Daniel

