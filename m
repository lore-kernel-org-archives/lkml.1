Return-Path: <linux-kernel-owner+w=401wt.eu-S1753457AbYEaKKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457AbYEaKKi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 06:10:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751601AbYEaKKb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 06:10:31 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34851 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750867AbYEaKKa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 06:10:30 -0400
Date: Sat, 31 May 2008 06:09:56 -0400
From: Alan Cox <alan@redhat.com>
To: devzero@web.de
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@redhat.com>, Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH] fix Kconfig after ip2/ip2main merge
Message-ID: <20080531100956.GA7615@devserv.devel.redhat.com>
References: <298760125@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <298760125@web.de>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a Lloegr o'r rhif cofrestru 3798903
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 31, 2008 at 02:43:09AM +0200, devzero@web.de wrote:
> as commit  6089093e588ee3f6aed99d08b1cf5ea37c52cf97  is fixing ip2 crashes on 
> load/unload and making ip2/ip2main one module (ip2),  Kconfig shouldn`t mention
> non existing module. I seldom posting patches and only have webmailer here, so 
> please indulge if there is something wrong with formatting or style.
> 
> Signed-off-by: Roland.Kletzing <devzero@web.de>

Acked-by: Alan Cox <alan@redhat.com>
