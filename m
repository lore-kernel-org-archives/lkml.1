Return-Path: <linux-kernel-owner+w=401wt.eu-S1754697AbYHMGHZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697AbYHMGHZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 02:07:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751784AbYHMGHP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 02:07:15 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:33656 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449AbYHMGHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 02:07:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=CnvQcEAWC+WgPyfWDAA2uGyfBWxJQHHwvunh7BdJ/lBEAa31eiuQKUpBbHueDzbHPW
         npuIzDKaM5f0L3Vl+XpOhhFnAKM6yvkIqFyhLb27b2Gs09qdLd+d7RuCB4BvW3p4b/TI
         fU4G2xmS/nBK/rYeM42jvA7iJ03D8CvPafWbk=
Subject: Re: [PATCH 19/22] x86: use the new byteorder headers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080812230205.680644a4.akpm@linux-foundation.org>
References: <1218587234.30194.93.camel@brick>
	 <20080812225612.6742aaf0.akpm@linux-foundation.org>
	 <20080812230205.680644a4.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 12 Aug 2008 23:07:15 -0700
Message-Id: <1218607635.30194.115.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-08-12 at 23:02 -0700, Andrew Morton wrote:
> On Tue, 12 Aug 2008 22:56:12 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > I'll drop them all.
> 
> btw, I had to rework several of these patches because everyone is
> moving include/asm-arch/* into arch/include/asm/.  Patches against
> linux-next would be preferred please.
> 

Which arches? These were all against linux-next20080811.

Harvey

