Return-Path: <linux-kernel-owner+w=401wt.eu-S1759609AbZCSJwe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759609AbZCSJwe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 05:52:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754782AbZCSJwZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 05:52:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36286 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754042AbZCSJwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 05:52:24 -0400
Date: Thu, 19 Mar 2009 02:45:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alex Chiang <achiang@hp.com>
Cc: jbarnes@virtuousgeek.org, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org, Trent Piepho <xyzzy@speakeasy.org>
Subject: Re: [PATCH v4 10/12] PCI Hotplug: restore fakephp interface with
 complete reimplementation
Message-Id: <20090319024555.1fed0dac.akpm@linux-foundation.org>
In-Reply-To: <20090318224016.887.47034.stgit@bob.kio>
References: <20090318222426.887.1008.stgit@bob.kio>
	<20090318224016.887.47034.stgit@bob.kio>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Mar 2009 16:40:16 -0600 Alex Chiang <achiang@hp.com> wrote:

> A complete re-implementation of fakephp is necessary if it is to
> present its former interface (pre-2.6.27, when it broke).

We broke an existing interface?  wtf?

If it's been broken for this long then do we actually need to
resurrect it?

If so, do we need to resurrect it in its old form?  This would appear
to be an opportunity to improve that interface, unless the old one
was perfect?
