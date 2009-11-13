Return-Path: <linux-kernel-owner+w=401wt.eu-S1754717AbZKMIce@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717AbZKMIce (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 03:32:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754098AbZKMIcb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 03:32:31 -0500
Received: from stinky.trash.net ([213.144.137.162]:44681 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753562AbZKMIca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 03:32:30 -0500
Message-ID: <4AFD19A0.90608@trash.net>
Date: Fri, 13 Nov 2009 09:32:32 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090701)
MIME-Version: 1.0
To: Roel Kluin <roel.kluin@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>,
       netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] netfilter: Should xt_osf_remove_callback() return negative
 on errors?
References: <4AFB3B9D.1080606@gmail.com>
In-Reply-To: <4AFB3B9D.1080606@gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roel Kluin wrote:
> Return a negative error value

Applied, thanks.
