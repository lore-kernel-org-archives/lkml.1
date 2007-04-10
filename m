Return-Path: <linux-kernel-owner+w=401wt.eu-S1030945AbXDJQQ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030945AbXDJQQ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 12:16:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031016AbXDJQQ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 12:16:58 -0400
Received: from ns1.suse.de ([195.135.220.2]:52992 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031013AbXDJQQ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 12:16:57 -0400
To: Michael Kerrisk <mtk-manpages@gmx.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: man-pages-2.44 is released
References: <46193754.40203@gmx.net>
From: Andi Kleen <andi@firstfloor.org>
Date: 10 Apr 2007 19:15:18 +0200
In-Reply-To: <46193754.40203@gmx.net>
Message-ID: <p73bqhwjgm1.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Kerrisk <mtk-manpages@gmx.net> writes:
> 
> time.7
>     mtk
>         Since kernel 2.6.20, the software clock can also be 300 HZ.

Well, since 2.6.21 it will be able to run at any HZ (hrtimers) 

-Andi
