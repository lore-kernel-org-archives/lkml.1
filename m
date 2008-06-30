Return-Path: <linux-kernel-owner+w=401wt.eu-S1759587AbYF3LAS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759587AbYF3LAS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 07:00:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755725AbYF3LAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 07:00:05 -0400
Received: from namei.org ([69.55.235.186]:38417 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754544AbYF3LAE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 07:00:04 -0400
Date: Mon, 30 Jun 2008 20:58:34 +1000 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: Hugh Dickins <hugh@veritas.com>
cc: Chris Wright <chrisw@sous-sol.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH trivial] security: remove unused forwards
In-Reply-To: <Pine.LNX.4.64.0806290054351.18327@blonde.site>
Message-ID: <Xine.LNX.4.64.0806302056490.23266@us.intercode.com.au>
References: <Pine.LNX.4.64.0806290054351.18327@blonde.site>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 Jun 2008, Hugh Dickins wrote:

> Why would linux/security.h need forward declarations for nfsctl_arg
> and swap_info_struct?  It's hard to imagine: remove them.

Probably for some removed and long-forgotten security hooks.

> 
> Signed-off-by: Hugh Dickins <hugh@veritas.com>
> ---

Acked-by: James Morris <jmorris@namei.org>


-- 
James Morris
<jmorris@namei.org>
