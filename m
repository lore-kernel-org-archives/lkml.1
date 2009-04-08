Return-Path: <linux-kernel-owner+w=401wt.eu-S933306AbZDHOKw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933306AbZDHOKw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 10:10:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763885AbZDHOKS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 10:10:18 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45213 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759224AbZDHOKQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 10:10:16 -0400
Date: Wed, 8 Apr 2009 09:05:25 -0500
From: David Teigland <teigland@redhat.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] dlm: Make name input parameter of {,dlm_}new_lockspace() const
Message-ID: <20090408140525.GA11662@redhat.com>
References: <Pine.LNX.4.64.0904072340220.27188@anakin>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0904072340220.27188@anakin>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 07, 2009 at 11:40:39PM +0200, Geert Uytterhoeven wrote:
> | fs/gfs2/lock_dlm.c:207: warning: passing argument 1 of 'dlm_new_lockspace' discards qualifiers from pointer target type
> 

Thanks, added to dlm.git.
Dave

