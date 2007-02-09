Return-Path: <linux-kernel-owner+w=401wt.eu-S1752518AbXBIXWe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752518AbXBIXWe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 18:22:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752540AbXBIXWe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 18:22:34 -0500
Received: from smtp.osdl.org ([65.172.181.24]:53848 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752518AbXBIXWd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 18:22:33 -0500
Date: Fri, 9 Feb 2007 15:22:19 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Hansen <hansendc@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 21/22] honor r/w changes at do_remount() time
Message-Id: <20070209152219.fa61d152.akpm@linux-foundation.org>
In-Reply-To: <20070209225344.93A75D35@localhost.localdomain>
References: <20070209225329.27619A62@localhost.localdomain>
	<20070209225344.93A75D35@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 09 Feb 2007 14:53:44 -0800
Dave Hansen <hansendc@us.ibm.com> wrote:

> This is the core of the read-only bind mount patch set.

Who wants read-only bind mounts, and for what reason?
