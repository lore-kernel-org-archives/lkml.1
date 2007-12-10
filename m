Return-Path: <linux-kernel-owner+w=401wt.eu-S1756953AbXLJS6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756953AbXLJS6U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 13:58:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752131AbXLJS6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 13:58:09 -0500
Received: from ns2.suse.de ([195.135.220.15]:36814 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753329AbXLJS6H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 13:58:07 -0500
Date: Mon, 10 Dec 2007 19:58:04 +0100
From: Andi Kleen <ak@suse.de>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Andi Kleen <ak@suse.de>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, rusty@rustcorp.com.au
Subject: Re: [PATCH RFC] [3/9] modpost: Declare the modpost error functions
	as printf like
Message-ID: <20071210185804.GB32466@bingen.suse.de>
References: <20071122343.446909000@suse.de> <20071122024308.9B40114D68@wotan.suse.de> <20071210185008.GA17315@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071210185008.GA17315@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 10, 2007 at 07:50:08PM +0100, Sam Ravnborg wrote:
> On Thu, Nov 22, 2007 at 03:43:08AM +0100, Andi Kleen wrote:
> > 
> > This way gcc can warn for wrong format strings
> 
> This loks good. Can I get i s-o-b then I will apply it.

Sorry must have been left out by mistake.

Signed-off-by: Andi Kleen <ak@suse.de>

for both patches.

-Andi

