Return-Path: <linux-kernel-owner+w=401wt.eu-S1030964AbXDXAiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030964AbXDXAiY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 20:38:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030971AbXDXAiY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 20:38:24 -0400
Received: from mail1.sea5.speakeasy.net ([69.17.117.3]:55654 "EHLO
	mail1.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030964AbXDXAiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 20:38:23 -0400
Date: Mon, 23 Apr 2007 20:38:21 -0400 (EDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@d.namei
To: Roland McGrath <roland@redhat.com>
cc: linux-kernel@vger.kernel.org, Stephen Smalley <sds@tycho.nsa.gov>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Return EPERM not ECHILD on security_task_wait failure
In-Reply-To: <20070424002641.5FB061801A4@magilla.sf.frob.com>
Message-ID: <Line.LNX.4.64.0704232038130.6142@d.namei>
References: <20070424002641.5FB061801A4@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Apr 2007, Roland McGrath wrote:

> As I said in some earlier discussion following my original patch, that
> would be fine with me.  I haven't coded up that variant, but it's simple
> enough.  Would you like to do it?

Sure.


-- 
James Morris
<jmorris@namei.org>
