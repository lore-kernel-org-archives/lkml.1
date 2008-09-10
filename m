Return-Path: <linux-kernel-owner+w=401wt.eu-S1753631AbYIJD76@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753631AbYIJD76 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 23:59:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752064AbYIJD7t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 23:59:49 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37619 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752052AbYIJD7t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 23:59:49 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Frank Mayhar <fmayhar@google.com>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.27-rc5] Fix itimer/many thread hang.
In-Reply-To: Frank Mayhar's message of  Monday, 8 September 2008 13:44:03 -0700 <1220906643.31846.21.camel@bobble.smo.corp.google.com>
References: <1220906643.31846.21.camel@bobble.smo.corp.google.com>
X-Windows: the joke that kills.
Message-Id: <20080910035945.A94991541FE@magilla.localdomain>
Date: Tue,  9 Sep 2008 20:59:45 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, Frank!  I won't have time to do a thorough fresh review of this
until after next week.  But from my recollection of the state of your patch
the last time we batted it around, I think it was getting close to right.
Oleg has a keen eye for this stuff.  I'm sure the next patch after
incorporating his review will be even closer.


Thanks,
Roland
