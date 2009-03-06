Return-Path: <linux-kernel-owner+w=401wt.eu-S1754596AbZCFJmc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596AbZCFJmc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 04:42:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751965AbZCFJmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 04:42:23 -0500
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:40872 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbZCFJmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 04:42:21 -0500
Message-ID: <49B0EFB6.8040107@s5r6.in-berlin.de>
Date: Fri, 06 Mar 2009 10:41:10 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.19) Gecko/20081204 SeaMonkey/1.1.14
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: state of the trees
References: <20090306155634.cc6c682d.sfr@canb.auug.org.au>
In-Reply-To: <20090306155634.cc6c682d.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
...
> the numbers following the
> name are the total number of outstanding commits (relative to all the
> preceding trees) and the number after doing "git patch-id" matching with
> Linus' tree and all the previous trees.  Thus the order of the trees
> makes a difference to the numbers.
...
> ieee1394		112	94

The precise number would be 44.  The rest are mostly commits which were
equivalently folded into larger ones and then merged into mainline.
-- 
Stefan Richter
-=====-==--= --== --==-
http://arcgraph.de/sr/
