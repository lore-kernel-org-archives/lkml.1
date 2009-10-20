Return-Path: <linux-kernel-owner+w=401wt.eu-S1753126AbZJTFIG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753126AbZJTFIG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 01:08:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752716AbZJTFIG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 01:08:06 -0400
Received: from kroah.org ([198.145.64.141]:59509 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752646AbZJTFIF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 01:08:05 -0400
Date: Mon, 19 Oct 2009 22:08:03 -0700
From: Greg KH <greg@kroah.com>
To: James Morris <jmorris@namei.org>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RFC] security: remove root_plug
Message-ID: <20091020050803.GA2902@kroah.com>
References: <alpine.LRH.2.00.0910201601340.14695@tundra.namei.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.0910201601340.14695@tundra.namei.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 20, 2009 at 04:02:58PM +1100, James Morris wrote:
> 
>     Remove the root_plug example LSM code.  It's unmaintained and
>     increasingly broken in various ways.
>     
>     Made at the 2009 Kernel Summit in Tokyo!
>     
>     Signed-off-by: James Morris <jmorris@namei.org>

Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

Thanks for doing this, I thought it was removed a while ago.

greg k-h
