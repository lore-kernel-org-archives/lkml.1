Return-Path: <linux-kernel-owner+w=401wt.eu-S1753705AbZEUKuH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753705AbZEUKuH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 06:50:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752394AbZEUKt5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 06:49:57 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:44587 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723AbZEUKt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 06:49:57 -0400
Date: Thu, 21 May 2009 12:49:52 +0200
From: Pavel Machek <pavel@ucw.cz>
To: =?iso-8859-1?Q?=C9ric?= Piel <eric.piel@tremplin-utc.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Isaac702 <isaac702@gmail.com>,
       Christian Weidle <slateroni@gmail.com>,
       Pavel Herrmann <morpheus.ibis@gmail.com>
Subject: Re: [PATCH 4/4] lis3: Add three new laptop models
Message-ID: <20090521104952.GB2637@elf.ucw.cz>
References: <4A151E9F.1080405@tremplin-utc.net> <4A151FFF.70406@tremplin-utc.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4A151FFF.70406@tremplin-utc.net>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2009-05-21 11:33:51, Éric Piel wrote:
> Separate the 6710 and 6715, and set the right axis information for the
> 6715.
> Reported-by: Isaac702 <isaac702@gmail.com>
> 
> Add the 6930.
> Reported-by: Christian Weidle <slateroni@gmail.com>
> 
> Add the 2710.
> Reported-by: Pavel Herrmann <morpheus.ibis@gmail.com>
> 
> Signed-off-by: Éric Piel <eric.piel@tremplin-utc.net>

Acked-by: Pavel Machek <pavel@ucw.cz>

Actually, I guess this should go before 2/4 and 3/4, as it is really
trivial.


								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
