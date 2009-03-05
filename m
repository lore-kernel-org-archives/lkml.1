Return-Path: <linux-kernel-owner+w=401wt.eu-S1755494AbZCEJOx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494AbZCEJOx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 04:14:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753611AbZCEJOi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 04:14:38 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:55589 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932AbZCEJOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 04:14:37 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Subject: Re: drop_caches ...
Cc: kosaki.motohiro@jp.fujitsu.com, Wu Fengguang <fengguang.wu@intel.com>,
       Markus <M4rkusXXL@web.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Zdenek Kabelac <zkabelac@redhat.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
In-Reply-To: <20090305090618.GB23266@ics.muni.cz>
References: <20090305004850.GA6045@localhost> <20090305090618.GB23266@ics.muni.cz>
Message-Id: <20090305181304.6758.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Thu,  5 Mar 2009 18:14:33 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hello,
> 
> On Thu, Mar 05, 2009 at 08:48:50AM +0800, Wu Fengguang wrote:
> > Markus, you may want to try this patch, it will have better chance to figure
> > out the hidden file pages.
> 
> just for curiosity, would it be possible to print process name which caused
> the file to be loaded into caches?

impossible.
kernel don't know which process populate page cache.





