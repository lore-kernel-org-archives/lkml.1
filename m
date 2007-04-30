Return-Path: <linux-kernel-owner+w=401wt.eu-S1423176AbXD3JJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423176AbXD3JJT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 05:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423185AbXD3JJT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 05:09:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38816 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423176AbXD3JJA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 05:09:00 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: bbpetkov@yahoo.de
Subject: Re: [PATCH] [9/26] x86_64: Fix vmalloc_32 to really allocate <4GB on 64bit platforms
Date: Mon, 30 Apr 2007 10:59:03 +0200
User-Agent: KMail/1.9.6
Cc: patches@x86-64.org, linux-kernel@vger.kernel.org
References: <20070430146.588463000@suse.de> <20070429234618.4CC7E150F2@wotan.suse.de> <20070430050133.GA4772@gollum.tnic>
In-Reply-To: <20070430050133.GA4772@gollum.tnic>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704301059.03141.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Isn't the following shorter:

Perhaps, but this is not a contest to write the shortest code. I think
mine is more clearer.

-Andi
