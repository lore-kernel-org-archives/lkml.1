Return-Path: <linux-kernel-owner+w=401wt.eu-S1758889AbYGKUWu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758889AbYGKUWu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 16:22:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754476AbYGKUWm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 16:22:42 -0400
Received: from [194.117.236.238] ([194.117.236.238]:54735 "EHLO
	heracles.linux360.ro" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752800AbYGKUWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 16:22:41 -0400
Date: Fri, 11 Jul 2008 23:21:19 +0300
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [RFC PATCH 4/5] kmemtrace: SLUB hooks.
Message-ID: <20080711232119.320e7122@linux360.ro>
In-Reply-To: <487772A3.5040701@linux-foundation.org>
References: <1215712946-23572-1-git-send-email-eduard.munteanu@linux360.ro>
	<1215712946-23572-2-git-send-email-eduard.munteanu@linux360.ro>
	<1215712946-23572-3-git-send-email-eduard.munteanu@linux360.ro>
	<1215712946-23572-4-git-send-email-eduard.munteanu@linux360.ro>
	<20080710210617.70975aed@linux360.ro>
	<84144f020807110135w19cb9b5erff143912e5beb78c@mail.gmail.com>
	<487772A3.5040701@linux-foundation.org>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jul 2008 09:48:03 -0500
Christoph Lameter <cl@linux-foundation.org> wrote:

> Pekka Enberg wrote:
>  
> > Christoph, can you please take a look at this?
> 
> Yeah. I saw it. Is there some high level description as to how this
> is going to be used?

I'll soon post a link to a repo that holds the userspace tool.
