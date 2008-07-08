Return-Path: <linux-kernel-owner+w=401wt.eu-S1754684AbYGHNic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684AbYGHNic (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 09:38:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752230AbYGHNiY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 09:38:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40349 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751475AbYGHNiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 09:38:24 -0400
Message-ID: <48736D0F.5080208@linux-foundation.org>
Date: Tue, 08 Jul 2008 08:35:11 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Gerald Schaefer <gerald.schaefer@de.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Yasunori Goto <y-goto@jp.fujitsu.com>,
       Dave Hansen <haveblue@us.ibm.com>, Andy Whitcroft <apw@shadowen.org>
Subject: Re: [PATCH] Make CONFIG_MIGRATION available w/o NUMA
References: <1215354957.9842.19.camel@localhost.localdomain>	 <4872319B.9040809@linux-foundation.org>	 <1215451689.8431.80.camel@localhost.localdomain>	 <48725480.1060808@linux-foundation.org>	 <1215455148.8431.108.camel@localhost.localdomain>	 <48726158.9010308@linux-foundation.org> <1215514245.4832.7.camel@localhost.localdomain>
In-Reply-To: <1215514245.4832.7.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Christoph Lameter <cl@linux-foundation.org>

Small nit: It now looks as if the vma_migratable() function belongs into mempolicy.h and not migrate.h

