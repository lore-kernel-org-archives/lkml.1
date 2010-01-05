Return-Path: <linux-kernel-owner+w=401wt.eu-S1755319Ab0AETPQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319Ab0AETPQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 14:15:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753660Ab0AETPK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 14:15:10 -0500
Received: from one.firstfloor.org ([213.235.205.2]:37049 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754200Ab0AETPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 14:15:07 -0500
Date: Tue, 5 Jan 2010 20:15:03 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Sam Ravnborg <sam@ravnborg.org>, Andi Kleen <andi@firstfloor.org>,
       linux-arch@vger.kernel.org, ebiederm@xmission.com,
       paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [2/9] Add a kernel_address() that works for data too
Message-ID: <20100105191503.GH1778@basil.fritz.box>
References: <20100105315.789846878@firstfloor.org> <20100105021527.1AB19B17C2@basil.firstfloor.org> <20100105085853.GA28126@merkur.ravnborg.org> <20100105190455.GE30868@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100105190455.GE30868@flint.arm.linux.org.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'd suggest the only way to identify the data segment in a generic way
> is to have everyone define _sdata, or more preferably _data (to be
> consistent with _text), to be the start of the data segment.

I agree. I'll take a look at that.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
