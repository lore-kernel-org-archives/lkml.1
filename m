Return-Path: <linux-kernel-owner+w=401wt.eu-S1755191AbYKZXPa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755191AbYKZXPa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 18:15:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752336AbYKZXPQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 18:15:16 -0500
Received: from smtp.knology.net ([24.214.63.101]:32855 "EHLO smtp.knology.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750934AbYKZXPO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 18:15:14 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Nov 2008 18:15:14 EST
Subject: Re: [PATCH-mm 5/8] typhoon: remove uses of __constant_{endian}
	helpers
From: David Dillow <dave@thedillows.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jeff Garzik <jeff@garzik.org>,
       David Miller <davem@davemloft.net>,
       linux-netdev <netdev@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1227733972.5511.127.camel@brick>
References: <1227733972.5511.127.camel@brick>
Content-Type: text/plain
Date: Wed, 26 Nov 2008 18:08:30 -0500
Message-Id: <1227740910.25756.0.camel@obelisk.thedillows.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-11-26 at 13:12 -0800, Harvey Harrison wrote:
> The base versions handle constant folding just fine.
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>

Acked-by: David Dillow <dave@thedillows.org>

