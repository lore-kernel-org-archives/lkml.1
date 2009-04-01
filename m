Return-Path: <linux-kernel-owner+w=401wt.eu-S934020AbZDATNo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934020AbZDATNo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 15:13:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932564AbZDATNf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 15:13:35 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:46359 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932204AbZDATNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 15:13:34 -0400
Date: Wed, 1 Apr 2009 21:15:37 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Robin Holt <holt@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [Patch 1/1] Fix compiler warning.
Message-ID: <20090401191536.GC29673@uranus.ravnborg.org>
References: <20090401190556.GH8925@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090401190556.GH8925@sgi.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 01, 2009 at 02:05:56PM -0500, Robin Holt wrote:
> Fix a minor compile warning when building on ia64.
> 
> Signed-off-by: Robin Holt <holt@sgi.com>

Can you please include the warning in the changelog.
And a more descriptive subject would be nice.
Something like:

	xpc_sn2: fix warning

You usual do so - so I assume this was just an oversight.

	Sam
