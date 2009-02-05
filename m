Return-Path: <linux-kernel-owner+w=401wt.eu-S1757354AbZBEPY6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757354AbZBEPY6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 10:24:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751972AbZBEPYt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 10:24:49 -0500
Received: from mx2.redhat.com ([66.187.237.31]:59711 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751699AbZBEPYt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 10:24:49 -0500
Date: Thu, 5 Feb 2009 10:24:42 -0500
From: Bill Nottingham <notting@redhat.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Harald Hoyer <harald@redhat.com>, linux-kernel@vger.kernel.org,
       power@bughost.org
Subject: Re: [PATCH] tracer for sys_open() - sreadahead
Message-ID: <20090205152442.GE6865@nostromo.devel.redhat.com>
Mail-Followup-To: Arjan van de Ven <arjan@infradead.org>,
	Harald Hoyer <harald@redhat.com>, linux-kernel@vger.kernel.org,
	power@bughost.org
References: <497F69A4.2070007@intel.com> <20090130202219.GA1253@ucw.cz> <20090203133251.GD29046@elte.hu> <gmeu0q$n13$1@ger.gmane.org> <20090205150705.GC6865@nostromo.devel.redhat.com> <20090205071444.390c19bc@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090205071444.390c19bc@infradead.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven (arjan@infradead.org) said: 
> you can strace init but you can't strace X
> (at least... last I tried it locked my box ;0)

You should be able to strace X, as long as you're not doing it *from* X.

Bill
