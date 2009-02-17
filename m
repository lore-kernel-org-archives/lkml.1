Return-Path: <linux-kernel-owner+w=401wt.eu-S1755112AbZBQUOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755112AbZBQUOS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 15:14:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751685AbZBQUOE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 15:14:04 -0500
Received: from smtp3.ultrahosting.com ([74.213.175.254]:52116 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751253AbZBQUOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 15:14:01 -0500
Date: Tue, 17 Feb 2009 15:06:12 -0500 (EST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: Johannes Weiner <hannes@cmpxchg.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Chas Williams <chas@cmf.nrl.navy.mil>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [patch 1/7] slab: introduce kzfree()
In-Reply-To: <20090217184135.747921027@cmpxchg.org>
Message-ID: <alpine.DEB.1.10.0902171505570.24395@qirst.com>
References: <20090217182615.897042724@cmpxchg.org> <20090217184135.747921027@cmpxchg.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Acked-by: Christoph Lameter <cl@linux-foundation.org>


