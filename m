Return-Path: <linux-kernel-owner+w=401wt.eu-S1752928AbZHHPtv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752928AbZHHPtv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 11:49:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752634AbZHHPtt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 11:49:49 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:22189
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752631AbZHHPts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 11:49:48 -0400
X-IronPort-AV: E=Sophos;i="4.43,346,1246831200"; 
   d="scan'208";a="44472979"
Message-ID: <4A7D9EA6.6010401@inria.fr>
Date: Sat, 08 Aug 2009 17:49:58 +0200
From: Brice Goglin <Brice.Goglin@inria.fr>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andreas Herrmann <andreas.herrmann3@amd.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH 0/5 v4] x86: Adapt CPU topology detection for AMD	Magny-Cours
References: <20090805154402.GA6520@alberich.amd.com> <20090808151731.GD28892@elte.hu>
In-Reply-To: <20090808151731.GD28892@elte.hu>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> You also indicated that you'll address the feedback from Brice 
> Goglin to make the semantics (and naming) more consistent across the 
> kernel.
>   

It's done in the updated patchset that Andreas sent yesterday (in patch
4/8).

Brice

