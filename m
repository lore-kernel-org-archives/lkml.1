Return-Path: <linux-kernel-owner+w=401wt.eu-S1762793AbYDUQUq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762793AbYDUQUq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 12:20:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754155AbYDUQUi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 12:20:38 -0400
Received: from rn-out-0910.google.com ([64.233.170.190]:40888 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753672AbYDUQUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 12:20:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=lQ645gc6pzsQCtPNhMWsAHbv7RM8rYHr5nBS8iCeyOKzB1uELlIufhud+/A75meSkxW0VArmGuEJoxqfsoAY0eRMbT4uFIamLzIwrmKXTytBIgFmy4hOR7KBLdkO6/1u/CaIcUePYRPSMQ+NuG3WcVCSPqHFrKOAD+/mfNERzmU=
Date: Mon, 21 Apr 2008 12:20:14 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 29/37] Input: fix ordering in joystick Makefile
Message-ID: <20080421162014.GA7819@anvil.corenet.prv>
References: <cover.1208783694.git.dmitry.torokhov@gmail.com> <1b8930dc64b6842e50711441ba67482aacc475dd.1208783694.git.dmitry.torokhov@gmail.com> <Pine.LNX.4.64.0804211532090.12972@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0804211532090.12972@jikos.suse.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On Mon, Apr 21, 2008 at 03:40:05PM +0200, Jiri Kosina wrote:
> On Mon, 10 Mar 2008, Jiri Kosina wrote:
> 
> > Make entries in drivers/input/joystick/Makefile properly alphabetically
> > ordered.
> > Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> > Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
> 
> Hi Dmitry,
> 
> this patch of mine assumed that the driver for SEGA Dreamcast controller 
> [1] is merged, but it doesn't seem to be present in the lineup you have 
> sent ... ?
> 

The maple driver is not quite ready yet, I sent my comments to Adrian
and he is going to send me a new patch soon. Unfortunately I screwed up
the merge process trying to carve it out of the patch stream. I will fix
it before sending request to Linus.

-- 
Dmitry
