Return-Path: <linux-kernel-owner+w=401wt.eu-S1757080AbYGaVRt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757080AbYGaVRt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 17:17:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752693AbYGaVRk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 17:17:40 -0400
Received: from smtpout3.tre.se ([80.251.192.228]:36095 "EHLO smtpout3.tre.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752666AbYGaVRj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 17:17:39 -0400
Date: Thu, 31 Jul 2008 23:18:28 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Andreas Gruenbacher <agruen@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [genksyms patch 2/4] Include extern information in dumps
Message-ID: <20080731211828.GB25921@uranus.ravnborg.org>
References: <20080721022823.896799736@suse.de> <20080721025912.901688346@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080721025912.901688346@suse.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2008 at 04:28:25AM +0200, Andreas Gruenbacher wrote:
> The extern flag currently is not included in type dump files
> (genksyms --dump-types). Include that flag there for completeness.
> 
> Signed-off-by: Andreas Gruenbacher <agruen@suse.de>

Applied to kbuild-fixes.

The reamining two patches will wait until I get a closer look
at them.

	Sam
