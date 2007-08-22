Return-Path: <linux-kernel-owner+w=401wt.eu-S1761985AbXHVKYq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761985AbXHVKYq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 06:24:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755578AbXHVKYh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 06:24:37 -0400
Received: from mx2.suse.de ([195.135.220.15]:56391 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756298AbXHVKYg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 06:24:36 -0400
To: Russ Dill <Russ.Dill@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: What must I do to get HPET
References: <loom.20070822T045428-445@post.gmane.org>
From: Andi Kleen <andi@firstfloor.org>
Date: 22 Aug 2007 13:18:28 +0200
In-Reply-To: <loom.20070822T045428-445@post.gmane.org>
Message-ID: <p73y7g3yfzv.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Russ Dill <Russ.Dill@gmail.com> writes:

> I have an Acer Ferrari 5000 laptop, it has an AMD64 TL-60 processor, and an
> RS480 host bridge. I'm running 2.6.22, I get no HPET.

Actually it needs the 'HPET' table.

> Do I need to get Acer to update the BIOS to include a PNP0103 entry? Is there
> some way I can force this?

Yes they'll need to update the BIOS. They likely have one available
unless it's an old box because AFAIK getting a Vista logo requires HPET.

-Andi
