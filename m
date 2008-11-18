Return-Path: <linux-kernel-owner+w=401wt.eu-S1752525AbYKRJpA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752525AbYKRJpA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 04:45:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751585AbYKRJov
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 04:44:51 -0500
Received: from lazybastard.de ([212.112.238.170]:38857 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341AbYKRJou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 04:44:50 -0500
Date: Tue, 18 Nov 2008 10:44:40 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH 3/7] Improve alloc_percpu: expose percpu_modalloc and percpu_modfree
Message-ID: <20081118094439.GA17733@logfs.org>
References: <20081117132630.AC29EDDDFF@ozlabs.org> <20081117134713.GA8949@logfs.org> <200811180854.52492.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200811180854.52492.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 November 2008 08:54:52 +1030, Rusty Russell wrote:
> On Tuesday 18 November 2008 00:17:13 Jörn Engel wrote:
> >
> > You didn't test the patches much, did you? :)
> 
> No, not UP :)  I'd spent over four hours on them, so I figured it was time to
> post them and get some concrete discussion.

Oh, absolutely.  I just wish I could give a more substantial comment to
all this.

Jörn

-- 
A defeated army first battles and then seeks victory.
-- Sun Tzu
