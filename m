Return-Path: <linux-kernel-owner+w=401wt.eu-S1763453AbZD3N52@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763453AbZD3N52 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 09:57:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758805AbZD3N5O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 09:57:14 -0400
Received: from cantor.suse.de ([195.135.220.2]:38275 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761219AbZD3N5N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 09:57:13 -0400
Date: Thu, 30 Apr 2009 15:57:08 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Marc Pignat <Marc.Pignat@hevs.ch>
Cc: linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] 2.6.30-rc4 hid bluetooth not working
In-Reply-To: <49F9C1AD020000BF00029086@mailgw2.hevs.ch>
Message-ID: <alpine.LRH.2.00.0904301556310.2050@twin.jikos.cz>
References: <49F9C1AD020000BF00029086@mailgw2.hevs.ch>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Apr 2009, Marc Pignat wrote:

> My bluetooth keyboard is not working any more in rc4, but was working in 
> rc3.
> Here is the dmesg output, triggered by the first key press on the 
> keyboard, fortunately, this is 100% reproductible (once per boot).

Does reverting f3784d834c7 fix the problem?

-- 
Jiri Kosina
SUSE Labs

