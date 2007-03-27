Return-Path: <linux-kernel-owner+w=401wt.eu-S1753170AbXC0DkB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753170AbXC0DkB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 23:40:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753095AbXC0DkB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 23:40:01 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:5557 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753152AbXC0DkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 23:40:00 -0400
X-IronPort-AV: i="4.14,331,1170651600"; 
   d="scan'208"; a="32686423:sNHT23741221"
Subject: Re: [PATCH -mm] Blackfin arch: add kdebug header file
From: "Wu, Bryan" <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Arnd Bergmann <arnd@arndb.de>
Cc: bryan.wu@analog.com, Andrew Morton <akpm@linux-foundation.org>,
       Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org
In-Reply-To: <200703262345.09489.arnd@arndb.de>
References: <1174903941.32691.72.camel@roc-desktop>
	 <200703262345.09489.arnd@arndb.de>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Tue, 27 Mar 2007 11:40:37 +0800
Message-Id: <1174966837.6966.13.camel@roc-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-03-26 at 23:45 +0200, Arnd Bergmann wrote:
> I can see nothing wrong with your patches, but you should make the
> patch descriptions a little clearer:
> 

Thanks Arnd. I posted almost ten patches yesterday. Converting ten
patches to preformatted Emails is terrible manually, you know.

How does a kernel guru to do this, send out dozens of patch emails a
day? Is there any convenient tools to help this?

> On Monday 26 March 2007, Wu, Bryan wrote:
> > Hi folks,
> 
> No need for this line, if it's there, Andrew just needs to remove
> it from the changelog.
> 
> > This patch adds kdebug.h header file to blackfin architecture.
> 
> This line is completely redundant, as it states the same information
> as the subject. You should give some background information here,
> like:
> 
> kdebug.h is needed for kprobes.
> 
> For trivial patches where the subject already tells the whole story
> (e.g. 'remove redundant declaration of foo'), just leave out the
> description entirely except for the Signed-off-by.
> 
> 	Arnd <><
> you can even leave out the description

I really appreciate your warmly advice.

Best Regards,
Bryan
