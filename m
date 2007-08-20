Return-Path: <linux-kernel-owner+w=401wt.eu-S1760785AbXHTRdE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760785AbXHTRdE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 13:33:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756421AbXHTRcy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 13:32:54 -0400
Received: from mx2.suse.de ([195.135.220.15]:33704 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755322AbXHTRcx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 13:32:53 -0400
To: Konstantin Baydarov <kbaidarov@ru.mvista.com>
Cc: RT <linux-rt-users@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kexec: reenable HPET before kexec
References: <20070820205530.1ffd5876@windmill.dev.rtsoft.ru>
From: Andi Kleen <andi@firstfloor.org>
Date: 20 Aug 2007 20:26:38 +0200
In-Reply-To: <20070820205530.1ffd5876@windmill.dev.rtsoft.ru>
Message-ID: <p73tzquysdd.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Konstantin Baydarov <kbaidarov@ru.mvista.com> writes:

> Hi, I've faced problem:
> I have two x86_64 kernels with HPET enabled:

Is this for a standard kernel or for a RT kernel?

-Andi
