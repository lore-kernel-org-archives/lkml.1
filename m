Return-Path: <linux-kernel-owner+w=401wt.eu-S1750985AbXDPHbi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750985AbXDPHbi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 03:31:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753316AbXDPHbi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 03:31:38 -0400
Received: from mx1-2.mail.ru ([194.67.23.121]:6974 "EHLO mx1.mail.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750985AbXDPHbi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 03:31:38 -0400
X-Greylist: delayed 44632 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Apr 2007 03:31:38 EDT
Date: Mon, 16 Apr 2007 11:32:04 +0400
From: Evgeniy Dushistov <dushistov@mail.ru>
To: Dale Amon <amon@vnl.com>, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Problem with ufs nextstep in 2.6.18 (debian)
Message-ID: <20070416073204.GA10225@rain>
Mail-Followup-To: Dale Amon <amon@vnl.com>, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>The error also happens in 2.6.19, same as in 2.6.18.
>I extracted this from syslog: 
>Apr 17 00:14:15 kdev kernel: UFS-fs error (device loop0):
>ufs_check_page: bad entry

Is this happened also with this patch:
http://lkml.org/lkml/diff/2007/2/5/75/1
?

-- 
/Evgeniy

