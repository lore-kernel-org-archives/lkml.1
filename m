Return-Path: <linux-kernel-owner+w=401wt.eu-S1755481AbXFOMjd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755481AbXFOMjd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 08:39:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753340AbXFOMjY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 08:39:24 -0400
Received: from ns2.suse.de ([195.135.220.15]:44848 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753016AbXFOMjX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 08:39:23 -0400
From: Andi Kleen <ak@suse.de>
To: David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] Introduce compat_u64 and compat_s64 types
Date: Fri, 15 Jun 2007 14:38:51 +0200
User-Agent: KMail/1.9.1
Cc: Arnd Bergmann <arnd@arndb.de>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Airlie <airlied@linux.ie>, linux-arch@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
References: <200706150159.l5F1xNgM000459@hera.kernel.org> <200706151355.57464.ak@suse.de> <1181908836.25228.452.camel@pmac.infradead.org>
In-Reply-To: <1181908836.25228.452.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706151438.51803.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> It's the _location_ which is wrong;

As long as everybody using it sees the attribute packed it is not wrong at 
all. ABIs are just a convention, not a law.

-Andi
