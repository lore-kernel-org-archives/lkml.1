Return-Path: <linux-kernel-owner+w=401wt.eu-S1753207AbXE3IPF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753207AbXE3IPF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 04:15:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751288AbXE3IOw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 04:14:52 -0400
Received: from cantor.suse.de ([195.135.220.2]:50693 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750803AbXE3IOv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 04:14:51 -0400
To: Stephane Eranian <eranian@frankl.hpl.hp.com>
Cc: linux-kernel@vger.kernel.org, eranian@hpl.hp.com
Subject: Re: [PATCH 05/22] 2.6.22-rc3 perfmon2 : sampling format support
References: <200705291348.l4TDmJNe019671@frankl.hpl.hp.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 30 May 2007 11:11:32 +0200
In-Reply-To: <200705291348.l4TDmJNe019671@frankl.hpl.hp.com>
Message-ID: <p73myzmekvv.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stephane Eranian <eranian@frankl.hpl.hp.com> writes:
> 
> Each format is identified via a 128-bit UUID which can be requested
> when the context is created with pfm_create_context().

Why does it need a uuid? Isn't a name enough?

There is no documentation how the locking in this file works.

-Andi
