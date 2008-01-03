Return-Path: <linux-kernel-owner+w=401wt.eu-S1754936AbYACNI3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754936AbYACNI3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 08:08:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752786AbYACNGt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 08:06:49 -0500
Received: from mail.suse.de ([195.135.220.2]:56763 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751331AbYACNG3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 08:06:29 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] [19/20] x86: Use shorter addresses in i386 segfault printks
Date: Thu, 3 Jan 2008 13:56:32 +0100
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
References: <20080103149.088038000@suse.de> <20080103005015.3F5C714D40@wotan.suse.de> <20080103105614.GF29194@elte.hu>
In-Reply-To: <20080103105614.GF29194@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801031356.32313.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 03 January 2008 11:56:14 Ingo Molnar wrote:
> 
> * Andi Kleen <ak@suse.de> wrote:
> 
> > x86: Use shorter addresses in i386 segfault printks
> 
> hm, why? It's pretty well-established that we print addresses 8 char 
> wide on 32-bit.

It's useless. What purpose does it have?

-Andi
