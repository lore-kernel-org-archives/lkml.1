Return-Path: <linux-kernel-owner+w=401wt.eu-S1753779AbZGTVgp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753779AbZGTVgp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 17:36:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752537AbZGTVgp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 17:36:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53624 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753516AbZGTVgn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 17:36:43 -0400
Date: Mon, 20 Jul 2009 14:34:29 -0700
From: Greg KH <gregkh@suse.de>
To: Alejandro Riveira =?iso-8859-1?Q?Fern=E1ndez?= 
	<ariveira@gmail.com>
Cc: Damien Wyart <damien.wyart@free.fr>,
       Wolfgang Walter <wolfgang.walter@stwm.de>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Re: Linux 2.6.30.2: does not boot
Message-ID: <20090720213429.GA2012@suse.de>
References: <20090720040813.GC11940@kroah.com>
 <200907201613.22483.wolfgang.walter@stwm.de>
 <20090720150916.GB10015@suse.de>
 <20090720180333.GA2905@brouette>
 <20090720212318.2aa5be21@varda>
 <20090720194229.GB29819@suse.de>
 <20090720215032.476c54b5@varda>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090720215032.476c54b5@varda>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 20, 2009 at 09:50:32PM +0200, Alejandro Riveira Fernández wrote:
> El Mon, 20 Jul 2009 12:42:29 -0700
> Greg KH <gregkh@suse.de> escribió:
> 
> 
> > 
> > What revert do you find needed?
> 
>  Full story here: 
> http://bugzilla.kernel.org/show_bug.cgi?id=13362
> 
>  i'm reverting 7e0986c17f695952ce5d61ed793ce048ba90a661 for my own
> use. The mail threath with Ivo seems to indicate that my hardware 
> is weird so i do not think the problem will be resolved anytime soon
> People lost interest i guess

Ah, ok, I was worried that I had missed something here :)

thanks for the info,

greg k-h
