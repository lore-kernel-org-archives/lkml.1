Return-Path: <linux-kernel-owner+w=401wt.eu-S1761219AbZJIRSg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761219AbZJIRSg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 13:18:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761180AbZJIRSg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 13:18:36 -0400
Received: from kroah.org ([198.145.64.141]:48170 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761079AbZJIRSf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 13:18:35 -0400
Date: Fri, 9 Oct 2009 10:14:40 -0700
From: Greg KH <greg@kroah.com>
To: Bruce Beare <bbeare1@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
       Bruce Beare <bbeare@localhost.localdomain>,
       linux-kernel@vger.kernel.org, Manuel Gebele <forensixs@gmx.de>
Subject: Re: [PATCH] Space required before ".member = ..." in structure
 defn/assignments.
Message-ID: <20091009171440.GB4178@kroah.com>
References: <bbeare1@gmail.com>
 <1255052298-5856-1-git-send-email-bbeare1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1255052298-5856-1-git-send-email-bbeare1@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 08, 2009 at 06:38:18PM -0700, Bruce Beare wrote:
> From: Bruce Beare <bbeare@localhost.localdomain>
> 
> 
> Signed-off-by: Bruce Beare <bbeare1@gmail.com>
> ---
>  drivers/staging/comedi/drivers/vmk80xx.c |   24 ++++++++++++------------
>  1 files changed, 12 insertions(+), 12 deletions(-)

Oops, sorry, someone else already made this fix to the tree, someone
named Bruce Jones :)

thanks,

greg k-h
