Return-Path: <linux-kernel-owner+w=401wt.eu-S1755952AbYDYEPD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755952AbYDYEPD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 00:15:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751353AbYDYEOy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 00:14:54 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:47715 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbYDYEOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 00:14:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=ADU71Tiy265QeRSFzCckXh4OQEvc/ZosthrXUOEzsDPKTebD40hnAWuz6RRYg2jK4r0pdbs4IglBMiUQkQpkVce66w7MK+QRjXcXna/stGGADLp0kki/l0MxxTdg4tPbtaB+I1eGu7SLESGgzxsc8D0VGjBtSUbKJppH3tCC3R8=
Date: Fri, 25 Apr 2008 00:14:42 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Bryan Wu <cooloney@kernel.org>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Michael Hennerich <michael.hennerich@analog.com>
Subject: Re: [PATCH 1/1] [INPUT/KEYBOARD] Blackfin BF54x: Add
	infrastructure for keypad wakeups
Message-ID: <20080425041441.GA13328@anvil.corenet.prv>
References: <1209095728-21119-1-git-send-email-cooloney@kernel.org> <386072610804242106r123e6334id39a18002915464e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <386072610804242106r123e6334id39a18002915464e@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2008 at 12:06:13PM +0800, Bryan Wu wrote:
> On Fri, Apr 25, 2008 at 11:55 AM, Bryan Wu <cooloney@kernel.org> wrote:
> > From: Michael Hennerich <michael.hennerich@analog.com>
> >
> >  Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
> >  Signed-off-by: Bryan Wu <cooloney@kernel.org>
> >  ---
> >   drivers/input/keyboard/bf54x-keys.c |   36 ++++++++++++++++++++++++++++++++--
> >   1 files changed, 33 insertions(+), 3 deletions(-)
> >
> 
> Hi Dmitry,
> 
> Sorry for resending this patch, I forget it was accept by you.
> Please ignore this.
> 

No worries. Thanks Bryan.

-- 
Dmitry
