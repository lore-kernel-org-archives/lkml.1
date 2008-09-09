Return-Path: <linux-kernel-owner+w=401wt.eu-S1756201AbYIIT4d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756201AbYIIT4d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 15:56:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753976AbYIIT4Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 15:56:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51198 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753796AbYIIT4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 15:56:23 -0400
Date: Tue, 9 Sep 2008 12:56:13 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Sanders <linux@sandersweb.net>
cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       x86 maintainers <x86@kernel.org>
Subject: Re: [git pull] x86 fixes
In-Reply-To: <200809091518.16311.linux@sandersweb.net>
Message-ID: <alpine.LFD.1.10.0809091255420.3117@nehalem.linux-foundation.org>
References: <200809081932.m88JWVZG013061@askone.hos.anvin.org> <200809091518.16311.linux@sandersweb.net>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 9 Sep 2008, David Sanders wrote:
> 
> I haven't seen this come across the wire in Linus's 2.6.27 tree.  We're still 
> going to do this right?

Latest version is out there now (leaving the gas-error-proofing for 
later),

		Linus
