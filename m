Return-Path: <linux-kernel-owner+w=401wt.eu-S1756877AbXLLBiW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756877AbXLLBiW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 20:38:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751874AbXLLBiM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 20:38:12 -0500
Received: from ozlabs.org ([203.10.76.45]:54400 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750897AbXLLBiK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 20:38:10 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH RFC] [3/9] modpost: Declare the modpost error functions as printf like
Date: Wed, 12 Dec 2007 12:37:58 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Andi Kleen <ak@suse.de>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20071122343.446909000@suse.de> <20071122024308.9B40114D68@wotan.suse.de> <20071210185008.GA17315@uranus.ravnborg.org>
In-Reply-To: <20071210185008.GA17315@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712121237.59101.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 11 December 2007 05:50:08 Sam Ravnborg wrote:
> On Thu, Nov 22, 2007 at 03:43:08AM +0100, Andi Kleen wrote:
> > This way gcc can warn for wrong format strings
>
> This loks good. Can I get i s-o-b then I will apply it.

Even better, switch the code to the standard warn/warnx/err/errx.

Cheers,
Rusty.
