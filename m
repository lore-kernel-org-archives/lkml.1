Return-Path: <linux-kernel-owner+w=401wt.eu-S965512AbXDVIuu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965512AbXDVIuu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 04:50:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932339AbXDVIuu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 04:50:50 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:45421 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932255AbXDVIuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 04:50:50 -0400
Date: Sun, 22 Apr 2007 01:50:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Bastian Blank <bastian@waldi.eu.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Allow reading tainted flag as user
Message-Id: <20070422015045.f39d6ff7.akpm@linux-foundation.org>
In-Reply-To: <20070422083941.GA7945@wavehammer.waldi.eu.org>
References: <20070422083941.GA7945@wavehammer.waldi.eu.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Apr 2007 10:39:41 +0200 Bastian Blank <bastian@waldi.eu.org> wrote:

> The commit 34f5a39899f3f3e815da64f48ddb72942d86c366 restricted reading
> of the tainted value. The attached patch changes this back to a
> write-only check and restores the read behaviour of older versions.
> 
> Signed-off-by: Bastian Blank <bastian@waldi.eu.org>

there's no patch here.

And I'd be interested to see it, because Ted's patch converted it from 0444
to 0644, which sounds right.
