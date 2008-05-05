Return-Path: <linux-kernel-owner+w=401wt.eu-S1759859AbYEEO10@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759859AbYEEO10 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 10:27:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756143AbYEEO1K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 10:27:10 -0400
Received: from an-out-0708.google.com ([209.85.132.246]:30394 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753140AbYEEO1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 10:27:09 -0400
Message-ID: <fa686aa40805050727s4753f274k80159a9c07a48a3c@mail.gmail.com>
Date: Mon, 5 May 2008 08:27:08 -0600
From: "Grant Likely" <grant.likely@secretlab.ca>
To: monstr@seznam.cz
Subject: Re: [PATCH 1/1] DEBUGFS: Fixing name for debug fs
Cc: "Arnd Bergmann" <arnd@arndb.de>, paulus@samba.org,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
In-Reply-To: <481D73B0.8020705@monstr.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <monstr@seznam.cz>
	 <1209825314-8048-1-git-send-email-monstr@seznam.cz>
	 <c65b09261996cf3500b6faee201e2dd6c152973e.1209825194.git.monstr@monstr.eu>
	 <200805032307.04352.arnd@arndb.de> <481D73B0.8020705@monstr.eu>
X-Google-Sender-Auth: 90c074d0deab4419
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 4, 2008 at 2:28 AM, Michal Simek <monstr@monstr.eu> wrote:
> Hi Arnd,
>
>  This is question up to PowerPC guys not to me.
>  of_debugfs_root sounds good.

Make sure you cc: the linuxppc-dev@ozlabs.org mailing list on the next
iteration of this patch.

Cheers,
g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
