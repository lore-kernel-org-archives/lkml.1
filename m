Return-Path: <linux-kernel-owner+w=401wt.eu-S1757137AbZDOW6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757137AbZDOW6T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 18:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757141AbZDOW6D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 18:58:03 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56589 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756995AbZDOW6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 18:58:01 -0400
Date: Wed, 15 Apr 2009 15:55:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Shen Feng <shen@cn.fujitsu.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org,
       Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH] doc: add documentation for debugfs
Message-Id: <20090415155528.45b6cac7.akpm@linux-foundation.org>
In-Reply-To: <49E2E5CD.9050402@cn.fujitsu.com>
References: <49E2E5CD.9050402@cn.fujitsu.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Apr 2009 15:12:13 +0800
Shen Feng <shen@cn.fujitsu.com> wrote:

> 
> debugfs is used as a virtual filesystem devoted to debugging
> information. But it's not documented in Documentation/filesystems.
> Add one for it. The content is mainly from
> http://lwn.net/Articles/115405/

We should ask for Jon's permission, please?

That document is from 2004(!).  Did anyone check that it's still correct?

