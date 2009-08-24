Return-Path: <linux-kernel-owner+w=401wt.eu-S1753787AbZHXX0N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753787AbZHXX0N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 19:26:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753690AbZHXX0L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 19:26:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58430 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753638AbZHXX0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 19:26:11 -0400
Date: Mon, 24 Aug 2009 16:21:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Yohan <kernel@yohan.staff.proxad.net>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: VM issue causing high CPU loads
Message-Id: <20090824162155.ce323f08.akpm@linux-foundation.org>
In-Reply-To: <4A92A25A.4050608@yohan.staff.proxad.net>
References: <4A92A25A.4050608@yohan.staff.proxad.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Aug 2009 16:23:22 +0200
Yohan <kernel@yohan.staff.proxad.net> wrote:

> Hi,
> 
>     Is someone have an idea for that :
> 
>         http://bugzilla.kernel.org/show_bug.cgi?id=14024
> 

Please generate a kernel profile to work out where all the CPU tie is
being spent.  Documentation/basic_profiling.txt is a starting point.

Thanks.

