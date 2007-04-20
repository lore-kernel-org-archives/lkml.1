Return-Path: <linux-kernel-owner+w=401wt.eu-S1753537AbXDTNlE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537AbXDTNlE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 09:41:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753872AbXDTNlE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 09:41:04 -0400
Received: from mx2.suse.de ([195.135.220.15]:44934 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753537AbXDTNlD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 09:41:03 -0400
To: guilherme <guilherme@centralinf.com.br>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc7: HPET enabled freeze my machine at boot
References: <4628B0DA.3070907@centralinf.com.br>
	<p73mz133zr0.fsf@bingen.suse.de> <4628C045.3020503@centralinf.com.br>
From: Andi Kleen <andi@firstfloor.org>
Date: 20 Apr 2007 16:38:53 +0200
In-Reply-To: <4628C045.3020503@centralinf.com.br>
Message-ID: <p73irbr3ybm.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

guilherme <guilherme@centralinf.com.br> writes:

> With noapic it freezes too. This doesn't occur with 2.6.20.x thought.

Ah. Can you please git bisect it then? 

-Andi
