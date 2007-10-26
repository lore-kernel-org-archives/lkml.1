Return-Path: <linux-kernel-owner+w=401wt.eu-S1765284AbXJZVYX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765284AbXJZVYX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 17:24:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756082AbXJZVYM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 17:24:12 -0400
Received: from smtp-out.google.com ([216.239.33.17]:3934 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755644AbXJZVYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 17:24:10 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=yc7Hxi/X6OJxjj4LQKJJkwht3OohCPVSM999Nl+p5u+7DYUp7HMcqWCBEIGam6BlM
	BSgZjTDxGX8UiQYb749gA==
Date: Fri, 26 Oct 2007 14:22:54 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Matt Mackall <mpm@selenic.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Dave Hansen <haveblue@us.ibm.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Fengguang Wu <wfg@mail.ustc.edu.cn>
Subject: Re: [PATCH 6/12] maps4: simplify interdependence of maps and smaps
In-Reply-To: <7.430487409@selenic.com>
Message-ID: <alpine.DEB.0.9999.0710261422440.13709@chino.kir.corp.google.com>
References: <7.430487409@selenic.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Oct 2007, Matt Mackall wrote:

> From: Matt Mackall <mpm@selenic.com>
> 
> This pulls the shared map display code out of show_map and puts it in
> show_smap where it belongs.
> 
> Signed-off-by: Matt Mackall <mpm@selenic.com>
> Cc: Jeremy Fitzhardinge <jeremy@goop.org>
> Cc: David Rientjes <rientjes@google.com>

Acked-by: David Rientjes <rientjes@google.com>
