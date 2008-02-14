Return-Path: <linux-kernel-owner+w=401wt.eu-S934517AbYBNA4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934517AbYBNA4U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 19:56:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764379AbYBNA4K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 19:56:10 -0500
Received: from rv-out-0910.google.com ([209.85.198.186]:23494 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759729AbYBNA4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 19:56:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=pSWRbxXhDKVv99kSato9MXsKWTlIUo14i1YX/paknjTnDgFRhbrlQ8ceJjDIQ9z4x5OZbjHWesf16UVZHdlSuneapgLcif6NG5yXe2TwEi9NapdS4WwPQmJ0fBU+RVr2xiqxbrR/4Qe6fWaYy4KEF6aobVTFTK4ynCvb2qgq1fo=
Subject: Re: [PATCH-resend] jbd/jbd2: sparse warnings in revoke.c, journal.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: sct@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <20080213165041.05955133.akpm@linux-foundation.org>
References: <1202949217.18204.32.camel@brick>
	 <20080213165041.05955133.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 13 Feb 2008 16:55:56 -0800
Message-Id: <1202950564.18204.37.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-02-13 at 16:50 -0800, Andrew Morton wrote:
> On Wed, 13 Feb 2008 16:33:37 -0800
> Harvey Harrison <harvey.harrison@gmail.com> wrote:
> 
> > Subject: [PATCH-resend] jbd/jbd2: sparse warnings in revoke.c, journal.c
> 
> ext3/jbd and ext4/jbd2 patches usually find their way into the tree
> via different routes, so bundling these two fixes was inappropriate.
> 
> General guidelines: one patch per subsystem and one patch per concept.
> 
> Sometimes those guidelines get bent, but only occasionally.  Usually
> to avoid the silliness of handling a huge stream of one-line patches.

Sorry, should have known better.  Do you want a resend separately?

Harvey

