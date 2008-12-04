Return-Path: <linux-kernel-owner+w=401wt.eu-S1758020AbYLDSBy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758020AbYLDSBy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 13:01:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754669AbYLDSBp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 13:01:45 -0500
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:61182 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753919AbYLDSBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 13:01:44 -0500
Subject: Re: [PATCH] mm: remove UP version lru_add_drain_all()
From: Gerald Schaefer <gerald.schaefer@de.ibm.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
       y-goto@jp.fujitsu.com, npiggin@suse.de,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Christoph Lameter <cl@linux-foundation.org>
In-Reply-To: <20081204110013.1D62.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <1228342567.13111.11.camel@nimitz>
	 <20081204093143.390afa9f.kamezawa.hiroyu@jp.fujitsu.com>
	 <20081204110013.1D62.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Content-Type: text/plain
Date: Thu, 04 Dec 2008 19:01:39 +0100
Message-Id: <1228413699.18010.1.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.2) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-12-04 at 11:14 +0900, KOSAKI Motohiro wrote:
> Then this ifdef is not valueable.
> simple removing is better.
> 
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> CC: Christoph Lameter <cl@linux-foundation.org>
> CC: Lee Schermerhorn <Lee.Schermerhorn@hp.com>

Thanks, works for me.

Acked-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>

