Return-Path: <linux-kernel-owner+w=401wt.eu-S1752011AbXLZXkF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752011AbXLZXkF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 18:40:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751664AbXLZXjy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 18:39:54 -0500
Received: from namei.org ([69.55.235.186]:58109 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751423AbXLZXjy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 18:39:54 -0500
Date: Thu, 27 Dec 2007 10:39:44 +1100 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc6-mm1 - e1000 breakage
In-Reply-To: <20071226144621.0220aece.akpm@linux-foundation.org>
Message-ID: <Xine.LNX.4.64.0712271030520.9606@us.intercode.com.au>
References: <20071222233056.d652743e.akpm@linux-foundation.org>
 <30638.1198647786@turing-police.cc.vt.edu> <Xine.LNX.4.64.0712261833110.7815@us.intercode.com.au>
 <10809.1198657525@turing-police.cc.vt.edu> <Xine.LNX.4.64.0712261949060.10612@us.intercode.com.au>
 <Xine.LNX.4.64.0712270059270.5765@us.intercode.com.au>
 <20071226144621.0220aece.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Dec 2007, Andrew Morton wrote:

> > (under current -mm, the e1000 driver doesn't find my ethernet card & the 
> > tcl tests won't run without an external interface).
> 
> You might need to enable CONFIG_E1000E.

Indeed, it works for me.



- James 
-- 
James Morris 
<jmorris@namei.org>
