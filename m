Return-Path: <linux-kernel-owner+w=401wt.eu-S932785AbXC0EAq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932785AbXC0EAq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 00:00:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932848AbXC0EAq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 00:00:46 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:36715 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932785AbXC0EAp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 00:00:45 -0400
Date: Tue, 27 Mar 2007 12:57:34 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: "Wu, Bryan" <bryan.wu@analog.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] Blackfin arch: add kdebug header file
Message-ID: <20070327035734.GA25883@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	"Wu, Bryan" <bryan.wu@analog.com>, Arnd Bergmann <arnd@arndb.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <1174903941.32691.72.camel@roc-desktop> <200703262345.09489.arnd@arndb.de> <1174966837.6966.13.camel@roc-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1174966837.6966.13.camel@roc-desktop>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 27, 2007 at 11:40:37AM +0800, Wu, Bryan wrote:
> Thanks Arnd. I posted almost ten patches yesterday. Converting ten
> patches to preformatted Emails is terrible manually, you know.
> 
> How does a kernel guru to do this, send out dozens of patch emails a
> day? Is there any convenient tools to help this?
> 
Most people either have patch-bombing scripts or just use git to take
care of it. You should really consider the latter for getting updates
merged in the future, now that most of the initial troubles are resolved.
