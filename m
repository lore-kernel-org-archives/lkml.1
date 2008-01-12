Return-Path: <linux-kernel-owner+w=401wt.eu-S1762039AbYALSZL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762039AbYALSZL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 13:25:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756916AbYALSY7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 13:24:59 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52685 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756692AbYALSY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 13:24:58 -0500
Date: Sat, 12 Jan 2008 10:24:21 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Arjan van de Ven <arjan@infradead.org>
cc: linux-kernel@vger.kernel.org, mingo@elte.hu, akpm@linux-foundation.org,
       tglx@tglx.de, hpa@zytor.com
Subject: Re: [patch 0/8] Series to improve the x86 backtracing code
In-Reply-To: <20080111212623.518e1527@laptopd505.fenrus.org>
Message-ID: <alpine.LFD.1.00.0801121020430.2806@woody.linux-foundation.org>
References: <20080111212623.518e1527@laptopd505.fenrus.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 11 Jan 2008, Arjan van de Ven wrote:
> 
> this patch series improves the x86 backtracing code in the following ways:

I heartily approve of this series.

Good jorb. Especially the fact that you also fixed x86-64, which has been 
a total disaster in this area.

			Linus
