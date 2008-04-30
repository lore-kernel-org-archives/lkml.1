Return-Path: <linux-kernel-owner+w=401wt.eu-S1760341AbYD3IDz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760341AbYD3IDz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 04:03:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757249AbYD3IDg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 04:03:36 -0400
Received: from relay2.sgi.com ([192.48.171.30]:42611 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756993AbYD3IDf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 04:03:35 -0400
Date: Wed, 30 Apr 2008 03:03:35 -0500
From: Paul Jackson <pj@sgi.com>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: RFC: make MAINTAINERS email addresses easier to copy/paste
Message-Id: <20080430030335.4d269a83.pj@sgi.com>
In-Reply-To: <200804291500.39879.bjorn.helgaas@hp.com>
References: <200804291459.56300.bjorn.helgaas@hp.com>
	<200804291500.39879.bjorn.helgaas@hp.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch reminded me that I should update the CPUSETS maintainers,
which I will be sending in a separate patch shortly.

However, that in turn highlights one problem with updating several
MAINTAINERS entries at once; it will almost surely collide with
other ongoing updates to the MAINTAINERS file.  On that account,
your proposal might not be worth the extra effort it would take to
get merged ... I'm not sure.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
