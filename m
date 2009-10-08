Return-Path: <linux-kernel-owner+w=401wt.eu-S933261AbZJHXKe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933261AbZJHXKe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 19:10:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756966AbZJHXKc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 19:10:32 -0400
Received: from kroah.org ([198.145.64.141]:34451 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756045AbZJHXKb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 19:10:31 -0400
Date: Thu, 8 Oct 2009 15:57:24 -0700
From: Greg KH <greg@kroah.com>
To: Nitin Gupta <ngupta@vflare.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Marcin Slusarz <marcin.slusarz@gmail.com>, Ed Tomlinson <edt@aei.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, linux-mm-cc <linux-mm-cc@laptop.org>
Subject: Re: [PATCH 3/3] documentation
Message-ID: <20091008225724.GB22949@kroah.com>
References: <1253595414-2855-1-git-send-email-ngupta@vflare.org>
 <1253595414-2855-4-git-send-email-ngupta@vflare.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253595414-2855-4-git-send-email-ngupta@vflare.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 22, 2009 at 10:26:54AM +0530, Nitin Gupta wrote:
> Short guide on how to setup and use ramzswap.

Can you also send a patch that adds a drivers/staging/ramzswap/TODO file
that follows the format of the other drivers/staging/*/TODO file
describing what is needed to be done to get the code merged into the
main kernel tree?

thanks,

greg k-h
