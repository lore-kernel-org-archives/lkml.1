Return-Path: <linux-kernel-owner+w=401wt.eu-S1760228AbYCURdw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760228AbYCURdw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 13:33:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758871AbYCURdn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 13:33:43 -0400
Received: from relay2.sgi.com ([192.48.171.30]:41598 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753137AbYCURdn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 13:33:43 -0400
Date: Fri, 21 Mar 2008 10:32:11 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Eric Dumazet <dada1@cosmosbay.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [03/14] vmallocinfo: Support display of vcompound for a virtual
 compound page
In-Reply-To: <47E369D8.2010904@cosmosbay.com>
Message-ID: <Pine.LNX.4.64.0803211031530.18671@schroedinger.engr.sgi.com>
References: <20080321061703.921169367@sgi.com> <20080321061724.795229401@sgi.com>
 <47E369D8.2010904@cosmosbay.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Mar 2008, Eric Dumazet wrote:

> I would love to see NUMA information as well on vmallocinfo, but have
> currently no available time to prepare a patch.

Ok. Easy to add.
