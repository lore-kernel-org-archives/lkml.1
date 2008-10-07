Return-Path: <linux-kernel-owner+w=401wt.eu-S1755242AbYJGUD7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242AbYJGUD7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 16:03:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753844AbYJGUDw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 16:03:52 -0400
Received: from kroah.org ([198.145.64.141]:35846 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753807AbYJGUDv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 16:03:51 -0400
Date: Tue, 7 Oct 2008 13:00:31 -0700
From: Greg KH <greg@kroah.com>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1] Add c2 port support.
Message-ID: <20081007200031.GA7662@kroah.com>
References: <1223044589-31741-1-git-send-email-giometti@linux.it> <1223044589-31741-2-git-send-email-giometti@linux.it> <20081003215923.GA14890@kroah.com> <20081007093845.GD13035@tekkaman> <20081007173020.GA16654@kroah.com> <20081007191434.GK13035@tekkaman>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081007191434.GK13035@tekkaman>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2008 at 09:14:34PM +0200, Rodolfo Giometti wrote:
> On Tue, Oct 07, 2008 at 10:30:20AM -0700, Greg KH wrote:
> 
> > But you aren't submitting any clients here, right?  Are you planning to?
> 
> Currently not, but I have 2 clients for my custom boards... maybe I
> can add one of them which uses an x86 IO port to do the job.

Well, having a "core" with no clients doesn't make much sense, so you
should probably post some users of this code, otherwise why even have
it?

thanks,

greg k-h
