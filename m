Return-Path: <linux-kernel-owner+w=401wt.eu-S1758125AbYAUGLl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758125AbYAUGLl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 01:11:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752594AbYAUGLd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 01:11:33 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:53494 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751874AbYAUGLc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 01:11:32 -0500
Date: Mon, 21 Jan 2008 07:11:40 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH] kbuild: fix so modpost can now check any .o file
Message-ID: <20080121061140.GA27783@uranus.ravnborg.org>
References: <20080120200527.GA23852@uranus.ravnborg.org> <1200859743-24037-1-git-send-email-sam@ravnborg.org> <200801211156.32122.rusty@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801211156.32122.rusty@rustcorp.com.au>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 21, 2008 at 11:56:31AM +1100, Rusty Russell wrote:
> On Monday 21 January 2008 07:08:56 Sam Ravnborg wrote:
> > It is very convinient to say:
> > scripts/mod/modpost mm/built-in.o
> >
> > to check if any section mismatch errors occured
> > in mm/ (as an example).
> 
> Hi Sam,
> 
> In an ideal world, wouldn't it be better to split out section analysis into a 
> different helper program?

Now whats an ideal world ;-)
But otherwise yes - I have not just got around to it.

	Sam
