Return-Path: <linux-kernel-owner+w=401wt.eu-S1753049AbYIBMn5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753049AbYIBMn5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 08:43:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751360AbYIBMns
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 08:43:48 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:27730 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211AbYIBMnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 08:43:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=t0HmTgsSGMJrOSkz6YrV05IK+uAu+FaiZlkI+H5BX1vBTYMAUBRE/k256iKzeTL3XO
         7NjQfo9xB9XThq5pGBmykIC7bvxQMjZqXH/4vEKbAqoCywKTCNxs5x3PIsGxbzz/52S/
         s35XVg0KEIxjI5kUbedVfEPb1ZzEVRkDruwqI=
Date: Tue, 2 Sep 2008 08:43:43 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Daniel Barkalow <barkalow@iabervon.org>, linux-kernel@vger.kernel.org,
       Christopher Desjardins <cddesjardins@gmail.com>
Subject: Re: Lenovo 3000 N100 i8042 problems
Message-ID: <20080902083940.ZZRA012@mailhub.coreip.homeip.net>
References: <alpine.LNX.1.00.0808240148580.19665@iabervon.org> <Pine.LNX.4.64.0809020120130.29111@twin.jikos.cz> <alpine.LNX.1.00.0809012014280.19665@iabervon.org> <alpine.LNX.1.10.0809021121410.23448@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.1.10.0809021121410.23448@jikos.suse.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 02, 2008 at 11:23:25AM +0200, Jiri Kosina wrote:
> 
> so the product name both of System and Base Board are different, and 
> apparently the systems differ. Dmitry, what fields would you propose to be 
> put in the DMI matching here? I will do the patch then.
> 

I guess we could use System's product name to differentiate between
Cristopher's and Daniel's boards. Although I must admit it is the very
first time when I see a box that behaves better with active mux. DOes
Vista use active mux nowadays? Because if it is not then I bet there
is (or shortly will be) a BIOS update fixing legacy mode on Daniel's
box.

-- 
Dmitry
