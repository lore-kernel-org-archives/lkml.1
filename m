Return-Path: <linux-kernel-owner+w=401wt.eu-S1756278AbXJ0P2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756278AbXJ0P2T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 11:28:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753107AbXJ0P2I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 11:28:08 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40748 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752673AbXJ0P2G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 11:28:06 -0400
Date: Sat, 27 Oct 2007 11:27:44 -0400
From: Alan Cox <alan@redhat.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: Alan Cox <alan@redhat.com>, bzolnier@gmail.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] unexport ide_fix_driveid
Message-ID: <20071027152744.GA3113@devserv.devel.redhat.com>
References: <20071027141833.GT30533@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071027141833.GT30533@stusta.de>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a Lloegr o'r rhif cofrestru 3798903
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 27, 2007 at 04:18:33PM +0200, Adrian Bunk wrote:
> ide_fix_driveid can now be unexported.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Acked-by: Alan Cox <alan@redhat.com>

--
	"Where small clearances exist, controls are required to
	 prevent these clearances becoming negative"
			- How a standards body describes "not crashing"

