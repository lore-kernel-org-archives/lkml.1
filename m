Return-Path: <linux-kernel-owner+w=401wt.eu-S1752866AbYHDIGW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866AbYHDIGW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 04:06:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752054AbYHDIGK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 04:06:10 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:61447 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050AbYHDIGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 04:06:08 -0400
Subject: Re: [patch 3/3] kmsg: convert xpram messages to kmsg api.
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Pavel Machek <pavel@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
       lf_kernel_messages@lists.linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Michael Holzheu <holzheu@de.ibm.com>, Gerrit Huizenga <gh@us.ibm.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Randy Dunlap <randy.dunlap@oracle.com>, Jan Kara <jack@suse.cz>,
       Sam Ravnborg <sam@ravnborg.org>, Joe Perches <joe@perches.com>,
       Jochen Vo? <jochen.voss@googlemail.com>,
       Kunai Takashi <kunai@linux-foundation.jp>,
       Tim Bird <tim.bird@am.sony.com>
In-Reply-To: <20080804064853.GB23933@atrey.karlin.mff.cuni.cz>
References: <20080730165656.118280544@de.ibm.com>
	 <20080730171157.550296160@de.ibm.com>
	 <20080804064853.GB23933@atrey.karlin.mff.cuni.cz>
Content-Type: text/plain
Organization: IBM Corporation
Date: Mon, 04 Aug 2008 10:06:03 +0200
Message-Id: <1217837163.25291.3.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-08-04 at 08:48 +0200, Pavel Machek wrote:
> It is "Kernel command line". Plus, I do not think I find "User action"
> section really helpful here.

Ok, I'll fix that.

> ...user that does not understand what "between 1 and 32 means" is
> unlikely to know if the driver is built-in or module...

Yeah, it is a trivial example for a user action. Perhaps even too
trivial. On the other hand it doesn't hurt either. At least it is good
english thanks to our ID department.

-- 
blue skies,
  Martin.

"Reality continues to ruin my life." - Calvin.


