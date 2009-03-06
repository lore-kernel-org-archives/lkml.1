Return-Path: <linux-kernel-owner+w=401wt.eu-S1756710AbZCFR7Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756710AbZCFR7Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 12:59:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756375AbZCFR7A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 12:59:00 -0500
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:54060 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756682AbZCFR67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 12:58:59 -0500
Date: Fri, 6 Mar 2009 17:58:55 +0000
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Greg KH <gregkh@suse.de>,
       stable@kernel.org
Subject: Re: [PATCH] param: fix charp parameters set via sysfs
Message-ID: <20090306175854.GA28349@silver.sucs.org>
References: <200902171010.34819.rusty@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200902171010.34819.rusty@rustcorp.com.au>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 17, 2009 at 10:10:34AM +1030, Rusty Russell wrote:
> Impact: fix crash on reading from /sys/module/.../ieee80211_default_rc_algo

Is this too late to be queued for 2.6.30 (I guess it missed the current
window as it doesn't appear to be in 2.6.29-rc7)?

-- 
Sitsofe | http://sucs.org/~sits/
