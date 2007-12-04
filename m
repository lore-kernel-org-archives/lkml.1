Return-Path: <linux-kernel-owner+w=401wt.eu-S1753758AbXLDSz4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753758AbXLDSz4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 13:55:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754999AbXLDSze
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 13:55:34 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:48365 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228AbXLDSzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 13:55:31 -0500
Date: Tue, 4 Dec 2007 18:55:18 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@osdl.org>,
       Mike Mason <mmlnx@us.ibm.com>, Dipankar Sarma <dipankar@in.ibm.com>,
       David Smith <dsmith@redhat.com>
Subject: Re: [patch 1/2] Linux Kernel Markers - Support Multiple Probes
Message-ID: <20071204185517.GA21568@infradead.org>
References: <20071204181845.895090222@polymtl.ca> <20071204182402.940135178@polymtl.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071204182402.940135178@polymtl.ca>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I think this is complete overkill.  We should rather get one proper
tracing infrastructure in tree instead of having multiple hacking ones
in different places.  Yes, please consider this a NACK ;-)
