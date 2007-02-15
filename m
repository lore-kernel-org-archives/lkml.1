Return-Path: <linux-kernel-owner+w=401wt.eu-S965505AbXBOOhO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965505AbXBOOhO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 09:37:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965508AbXBOOhO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 09:37:14 -0500
Received: from mail2.sea5.speakeasy.net ([69.17.117.4]:57069 "EHLO
	mail2.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965505AbXBOOhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 09:37:13 -0500
Date: Thu, 15 Feb 2007 09:37:11 -0500 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@d.namei
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.20-mm1 [kernel BUG at mm/swap.c:442]
In-Reply-To: <Pine.LNX.4.64.0702150926560.25081@d.namei>
Message-ID: <Pine.LNX.4.64.0702150936300.25780@d.namei>
References: <20070215051408.a7fb7d81.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0702150926560.25081@d.namei>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Feb 2007, James Morris wrote:

> Hit a BUG() via lvm:

Also, I just disabled paravirt ops and saw the same bug, so it's not that 
stuff.


-- 
James Morris
<jmorris@namei.org>
