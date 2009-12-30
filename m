Return-Path: <linux-kernel-owner+w=401wt.eu-S1751871AbZL3BMA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751871AbZL3BMA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 20:12:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751577AbZL3BMA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 20:12:00 -0500
Received: from ns1.siteground211.com ([209.62.36.12]:52879 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455AbZL3BL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 20:11:59 -0500
Subject: Re: Question of resource_size() implementation
From: Felipe Balbi <me@felipebalbi.com>
Reply-To: me@felipebalbi.com
To: Ben Nizette <bn@niasdigital.com>
Cc: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org
In-Reply-To: <0CE3DF69-C498-44BA-8CEA-C9AA5DB4CF84@niasdigital.com>
References: <1262130234.28789.112.camel@gandalf>
	 <1262131932.1888.202.camel@Joe-Laptop.home>
	 <1262132171.28789.136.camel@gandalf>
	 <251FB18F-5D6A-4BBE-A69D-F6203E09058B@niasdigital.com>
	 <0CE3DF69-C498-44BA-8CEA-C9AA5DB4CF84@niasdigital.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 30 Dec 2009 03:11:54 +0200
Message-ID: <1262135514.28789.146.camel@gandalf>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - serv01.siteground211.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - felipebalbi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-30 at 12:08 +1100, Ben Nizette wrote:
> IOW it's a matter of convention.  Either we could define a single-byte 
> range to be end=start and put the +1 in the resource_size or we could 
> define a single-byte range to be end=start+1 and leave the +1 out of
> resource_size.  The in-kernel convention is the former

ok, thanks for the explanation Ben.

-- 
balbi

