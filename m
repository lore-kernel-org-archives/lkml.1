Return-Path: <linux-kernel-owner+w=401wt.eu-S1754549AbYKSS2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549AbYKSS2V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 13:28:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754621AbYKSS1o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 13:27:44 -0500
Received: from waste.org ([66.93.16.53]:55996 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754606AbYKSS1j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 13:27:39 -0500
Subject: Re: next-20081117: kernel freezes with netconsole enabled
From: Matt Mackall <mpm@selenic.com>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, satyam.sharma@gmail.com
In-Reply-To: <20081119175740.GE12456@orion>
References: <20081119175740.GE12456@orion>
Content-Type: text/plain
Date: Wed, 19 Nov 2008 12:27:31 -0600
Message-Id: <1227119251.3149.57.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-11-19 at 20:57 +0300, Alexander Beregalov wrote:
> Hi 
> 
> It is x86_64 SMP
> The kernel freezes while transferring kernel log through netconsole,
> SysRq does not work at that moment.

Does it survive if you boot with 'quiet'? Is this new behavior or have
you successfully used netconsole before?

-- 
Mathematics is the supreme nostalgia of our time.

