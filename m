Return-Path: <linux-kernel-owner+w=401wt.eu-S1765878AbYBUEBs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765878AbYBUEBs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 23:01:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755009AbYBUEBj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 23:01:39 -0500
Received: from py-out-1112.google.com ([64.233.166.182]:62323 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754942AbYBUEBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 23:01:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=QoklUWWwEhiDiCdVWcqSC9LNSGrvqGIUhz1hktasPTEYxmVLOiofOaaQOD6767xNHKHGDC4SgxuxGvtn45ggU1bRLCTtvuUvHuX1sNwAS7UemE5jZvZCd7brCTll8Sl0b5VWq02g3B/WxfeQtl2CtNXKPkKfgZxuzVJ+7F7FOfs=
Date: Wed, 20 Feb 2008 22:01:27 -0600
From: Josh Boyer <jwboyer@gmail.com>
To: Paul Mackerras <paulus@samba.org>
Cc: Kumar Gala <galak@kernel.crashing.org>, sparclinux@vger.kernel.org,
       linuxppc-dev@ozlabs.org, David Miller <davem@davemloft.net>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2][POWERPC] Fix initial lmb add region with a non-zero
 base
Message-ID: <20080220220127.08555476@vader.jdub.homelinux.org>
In-Reply-To: <18364.57054.427433.405627@cargo.ozlabs.ibm.com>
References: <Pine.LNX.4.64.0802191350590.10089@blarg.am.freescale.net>
	<20080219.163003.152862383.davem@davemloft.net>
	<4130F47E-4F4A-4911-B63B-403A8C423565@kernel.crashing.org>
	<18364.57054.427433.405627@cargo.ozlabs.ibm.com>
X-Mailer: Claws Mail 3.3.0 (GTK+ 2.12.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Feb 2008 13:15:58 +1100
Paul Mackerras <paulus@samba.org> wrote:

> Kumar Gala writes:
> 
> > np.  Are we trying to get this into 2.6.25 or .26?
> 
> I was going to put it into my powerpc-next branch and put it in
> 2.6.26.  I don't see any need for it to go in 2.6.25.

Is that a new branch you're going to create, or the normal "for-2.6.xx"?

josh
