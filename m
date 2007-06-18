Return-Path: <linux-kernel-owner+w=401wt.eu-S1763398AbXFRNQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763398AbXFRNQS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 09:16:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758286AbXFRNQH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 09:16:07 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:58470 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759450AbXFRNQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 09:16:05 -0400
Subject: Re: [RFC/PATCH] Documentation of kernel messages
From: Arjan van de Ven <arjan@infradead.org>
To: holzheu@linux.vnet.ibm.com
Cc: Gerrit Huizenga <gh@us.ibm.com>, Jan Kara <jack@suse.cz>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       randy.dunlap@oracle.com, gregkh@suse.de, mtk-manpages@gmx.net,
       schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
       "lf_kernel_messages@linux-foundation.org" 
	<lf_kernel_messages@linux-foundation.org>
In-Reply-To: <1182171354.11400.40.camel@localhost.localdomain>
References: <E1HzGkR-0008DO-Un@w-gerrit.beaverton.ibm.com>
	 <1182171354.11400.40.camel@localhost.localdomain>
Content-Type: text/plain
Organization: Intel International BV
Date: Mon, 18 Jun 2007 06:12:54 -0700
Message-Id: <1182172374.28566.1.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-06-18 at 14:55 +0200, holzheu wrote:
> Hi Gerrit,
> 
> The common thing of your and our approach is, that we need an ID to
> identify a message either by:


Maybe I am missing something big, but why is an ID needed?
The message IS the ID right? That's the only thing that is robust
against code moving about....

(And yes I am aware that very occasionally there might be a duplicate
message that REALLY is different, but I suspect that that is so
incredibly rare that it's just simpler to reword one of the two in such
case)


