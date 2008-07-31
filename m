Return-Path: <linux-kernel-owner+w=401wt.eu-S1754306AbYGaVSJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754306AbYGaVSJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 17:18:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752693AbYGaVRx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 17:17:53 -0400
Received: from smtpout3.tre.se ([80.251.192.228]:36122 "EHLO smtpout3.tre.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757799AbYGaVRv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 17:17:51 -0400
Date: Thu, 31 Jul 2008 23:17:51 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Andreas Gruenbacher <agruen@suse.de>
Cc: linux-kernel@vger.kernel.org, randy.dunlap@oracle.com,
       akpm@linux-foundation.org
Subject: Re: [genksyms patch 1/4] parser: fix the __attribute__ rule
Message-ID: <20080731211751.GA25921@uranus.ravnborg.org>
References: <20080721022823.896799736@suse.de> <20080721025912.739333284@suse.de> <20080730204311.GA17287@uranus.ravnborg.org> <200807310003.49279.agruen@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807310003.49279.agruen@suse.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2008 at 12:03:49AM +0200, Andreas Gruenbacher wrote:
> On Wednesday 30 July 2008 10:43:11 pm Sam Ravnborg wrote:
> > Can I ask you to update the _shipped files and resend the patch.
> 
> Sure, here is the version from Andrew's tree, with parse.c_shipped added.

Applied to kbuild-fixes.

	Sam
