Return-Path: <linux-kernel-owner+w=401wt.eu-S936436AbYEBTOO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936436AbYEBTOO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 15:14:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936598AbYEBTMO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 15:12:14 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:59230 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936508AbYEBTMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 15:12:03 -0400
Date: Fri, 2 May 2008 11:56:48 -0700
From: Greg KH <greg@kroah.com>
To: Badari Pulavarty <pbadari@us.ibm.com>
Cc: akpm@linux-foundation.org, Mel Gorman <mel@csn.ul.ie>,
       "kamezawa.hiroyu" <kamezawa.hiroyu@jp.fujitsu.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Add sysfs removable attribute for hotplug memory remove
Message-ID: <20080502185648.GA12991@kroah.com>
References: <1209747376.16169.27.camel@badari-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1209747376.16169.27.camel@badari-desktop>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 02, 2008 at 09:56:16AM -0700, Badari Pulavarty wrote:
> Hi Andrew,
> 
> Here is the updated/commented version of the sysfs "removability"
> attribute patch for hotplug memory remove (against 2.6.25-git18). 
> Could you please consider this for inclusion ?

Can you please add an entry in Documentation/ABI for this new attribute
you are adding?

thanks,

greg k-h
