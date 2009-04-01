Return-Path: <linux-kernel-owner+w=401wt.eu-S934034AbZDATWv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934034AbZDATWv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 15:22:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762542AbZDATWX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 15:22:23 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51811 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761200AbZDATWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 15:22:22 -0400
Date: Wed, 1 Apr 2009 12:19:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: holt@sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [Patch 1/1] Fix compiler warning.
Message-Id: <20090401121945.e4a17084.akpm@linux-foundation.org>
In-Reply-To: <20090401191536.GC29673@uranus.ravnborg.org>
References: <20090401190556.GH8925@sgi.com>
	<20090401191536.GC29673@uranus.ravnborg.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Apr 2009 21:15:37 +0200
Sam Ravnborg <sam@ravnborg.org> wrote:

> On Wed, Apr 01, 2009 at 02:05:56PM -0500, Robin Holt wrote:
> > Fix a minor compile warning when building on ia64.
> > 
> > Signed-off-by: Robin Holt <holt@sgi.com>
> 
> Can you please include the warning in the changelog.

yup.

> And a more descriptive subject would be nice.
> Something like:
> 
> 	xpc_sn2: fix warning

I routinely rewrite titles in that form.  Probably about a third of the
time.
