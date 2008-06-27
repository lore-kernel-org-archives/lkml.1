Return-Path: <linux-kernel-owner+w=401wt.eu-S1761122AbYF0NPp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761122AbYF0NPp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 09:15:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756485AbYF0NPa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 09:15:30 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50514 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756087AbYF0NP3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 09:15:29 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Nikanth Karthikesan <knikanth@suse.de>
Cc: linux-aio@kvack.org, linux-kernel@vger.kernel.org,
       Benjamin LaHaise <bcrl@kvack.org>, Zach Brown <zach.brown@oracle.com>
Subject: Re: [PATCH]  aio: remove unused function aio_run_iocbs()
References: <200806261640.27048.knikanth@suse.de>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Fri, 27 Jun 2008 09:15:17 -0400
In-Reply-To: <200806261640.27048.knikanth@suse.de> (Nikanth Karthikesan's
	message of "Thu, 26 Jun 2008 16:40:26 +0530")
Message-ID: <x49lk0rt3x6.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nikanth Karthikesan <knikanth@suse.de> writes:

> remove unused function aio_run_iocbs()

Seems like it's time to just get rid of it.  See:
  http://ussg.iu.edu/hypermail/linux/kernel/0608.0/0048.html
for an explanation of why it's still there.

Cheers,

Jeff
