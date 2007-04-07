Return-Path: <linux-kernel-owner+w=401wt.eu-S965407AbXDGFlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965407AbXDGFlU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 01:41:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965396AbXDGFlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 01:41:20 -0400
Received: from smtp-out.google.com ([216.239.45.13]:55920 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965397AbXDGFlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 01:41:14 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=vp1DeBtdr9MRL2aBlIC/WyzEShxR6hmf7yGJoPgDTTNBkU9LnAgsLXpaLUyk66jwR
	JuYk/jIUGrLjhrLLQq6Xg==
Date: Fri, 6 Apr 2007 22:41:00 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Matt Mackall <mpm@selenic.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/13] maps#2: Make /proc/pid/clear_refs option under
 CONFIG_EMBEDDED
In-Reply-To: <12.469046093@selenic.com>
Message-ID: <Pine.LNX.4.64.0704062240470.25380@chino.kir.corp.google.com>
References: <12.469046093@selenic.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Apr 2007, Matt Mackall wrote:

> Make /proc/pid/clear_refs option under CONFIG_EMBEDDED
> 
> This interface is primarily useful for doing memory profiling and not
> much use on deployed embedded boxes. Make it optional. Together with
> /proc/pid/smaps, this save a few K.
> 
> Signed-off-by: Matt Mackall <mpm@selenic.com>

Acked-by: David Rientjes <rientjes@google.com>
