Return-Path: <linux-kernel-owner+w=401wt.eu-S1755351Ab0AVXDk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351Ab0AVXDk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 18:03:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755127Ab0AVXDj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 18:03:39 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52614 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754502Ab0AVXDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 18:03:39 -0500
Date: Fri, 22 Jan 2010 15:03:25 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Harry Edmon <harry@atmos.washington.edu>
Cc: linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org
Subject: Re: 2.6.32.2 - WARNING: at lib/kref.c:43 kref_get+0x,23/0x2b()
Message-Id: <20100122150325.6ad12428.akpm@linux-foundation.org>
In-Reply-To: <4B4F5A00.4060604@atmos.washington.edu>
References: <4B4F5A00.4060604@atmos.washington.edu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc linux-nfs)

On Thu, 14 Jan 2010 09:53:04 -0800
Harry Edmon <harry@atmos.washington.edu> wrote:

> I have a single quad-core Xeon machine running 2.6.32.2 that keeps 
> giving me "WARNING: at lib/kref.c:43 kref_get+0x,23/0x2b()".  This 
> machine is mainaly used as a NFS server.  I have attached the kern.log 
> and my config file.   Any ideas?
> -- 
> 
>  Dr. Harry Edmon			E-MAIL: harry@atmos.washington.edu
>  206-543-0547 FAX: 206-543-0308		harry@washington.edu, harry@uw.edu
>  Director of IT, College of the Environment and
>  Director of Computing, Dept of Atmospheric Sciences
>  University of Washington, Box 351640, Seattle, WA 98195-1640
> 
> 
