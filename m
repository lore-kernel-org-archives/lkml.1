Return-Path: <linux-kernel-owner+w=401wt.eu-S1756288AbZBZChi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756288AbZBZChi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 21:37:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752694AbZBZCh0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 21:37:26 -0500
Received: from THUNK.ORG ([69.25.196.29]:47232 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752464AbZBZChZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 21:37:25 -0500
Date: Wed, 25 Feb 2009 21:37:14 -0500
From: Theodore Tso <tytso@mit.edu>
To: Yang Hongyang <yanghy@cn.fujitsu.com>
Cc: Yang Hongyang <imhy.yang@gmail.com>, netdev@vger.kernel.org,
       "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-doc@vger.kernel.org,
       mtk.manpages@gmail.com, rdunlap@xenotime.net
Subject: Re: Documentation:Update the INDEX of the documents
Message-ID: <20090226023714.GH1363@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Yang Hongyang <yanghy@cn.fujitsu.com>,
	Yang Hongyang <imhy.yang@gmail.com>, netdev@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-doc@vger.kernel.org, mtk.manpages@gmail.com,
	rdunlap@xenotime.net
References: <49A4F06B.6030205@cn.fujitsu.com> <20090225145950.GJ7064@mit.edu> <a669f14b0902250725j4c21463eqc1b88092486f38ad@mail.gmail.com> <20090225155628.GM7064@mit.edu> <49A5E72C.1080804@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49A5E72C.1080804@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 26, 2009 at 08:49:48AM +0800, Yang Hongyang wrote:
> Yeah ,if we do this one-line summary thing,we still have to go through
> all these documents. So why not just update the 00-INDEX and then tell
> the authors that will add docs to the kernel do the "00-INDEX work"
>  themselves?

The difference is that if we go through the documents, it's something
we do *once*.  And after the convention has been established, in the
long term, it should be less work for all concerned.

     	      	     	     	      	  - Ted
