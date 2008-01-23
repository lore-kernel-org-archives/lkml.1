Return-Path: <linux-kernel-owner+w=401wt.eu-S1754146AbYAWT6Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146AbYAWT6Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 14:58:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751750AbYAWT6E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 14:58:04 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43941 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751675AbYAWT6B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 14:58:01 -0500
To: Ryo Tsuruta <ryov@valinux.co.jp>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org,
       xen-devel@lists.xensource.com
Subject: Re: [PATCH 2/2] dm-band: The I/O bandwidth controller: Document
From: Andi Kleen <andi@firstfloor.org>
References: <20080123.215350.193721890.ryov@valinux.co.jp>
	<20080123.215844.71118155.ryov@valinux.co.jp>
Date: Wed, 23 Jan 2008 20:57:57 +0100
In-Reply-To: <20080123.215844.71118155.ryov@valinux.co.jp> (Ryo Tsuruta's message of "Wed\, 23 Jan 2008 21\:58\:44 +0900 \(JST\)")
Message-ID: <p73lk6g9uwq.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ryo Tsuruta <ryov@valinux.co.jp> writes:

> Here is the document of dm-band.

Could you please address in the document how the intended use
cases/feature set etc. differs from CFQ2 io priorities?

Thanks,

-Andi
