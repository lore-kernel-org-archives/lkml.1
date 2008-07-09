Return-Path: <linux-kernel-owner+w=401wt.eu-S1756910AbYGIOoo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756910AbYGIOoo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 10:44:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752764AbYGIOoe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 10:44:34 -0400
Received: from csclub.uwaterloo.ca ([129.97.134.17]:51315 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751224AbYGIOod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 10:44:33 -0400
Date: Wed, 9 Jul 2008 10:44:32 -0400
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: netdev@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: WAN: Remove dead code from wanmain.c, CONFIG_WANPIPE_MULTPPP doesn't exist
Message-ID: <20080709144432.GD31126@csclub.uwaterloo.ca>
References: <m3r6ac3xs8.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m3r6ac3xs8.fsf@maximus.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 02, 2008 at 09:12:55PM +0200, Krzysztof Halasa wrote:
> For review only, the actual patch will be made available in git.
> 
> Remove dead code from wanmain.c, CONFIG_WANPIPE_MULTPPP doesn't exist

Does anyone use this ancient code anymore?  Sangoma has been maintaining
their drivers out of tree for years now and the leftover bits (from 2.2
or 2.4 days) really isn't interesting anymore as far as I can tell.
Maybe removal entirely is the correct clean up method.

-- 
Len Sorensen
