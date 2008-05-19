Return-Path: <linux-kernel-owner+w=401wt.eu-S1764032AbYESUE2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764032AbYESUE2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 16:04:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760725AbYESUEO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 16:04:14 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41312 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760611AbYESUEM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 16:04:12 -0400
Date: Mon, 19 May 2008 15:02:55 -0500
From: David Teigland <teigland@redhat.com>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] <linux/dlm_plock.h> should be "unifdef"ed.
Message-ID: <20080519200255.GA3635@redhat.com>
References: <alpine.LFD.1.10.0805171656410.27432@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0805171656410.27432@localhost.localdomain>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 17, 2008 at 04:58:28PM -0400, Robert P. J. Day wrote:
> 
> Given that <linux/dlm_plock.h> contains a conditional __KERNEL__ test,
> it should be moved from header-y to unifdef-y.
> 
> Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>

Thanks, I've added this to dlm.git.
Dave

