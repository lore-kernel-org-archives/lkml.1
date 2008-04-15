Return-Path: <linux-kernel-owner+w=401wt.eu-S1763769AbYDOFij@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763769AbYDOFij (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 01:38:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754050AbYDOFid
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 01:38:33 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:47394 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753941AbYDOFic (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 01:38:32 -0400
Date: Tue, 15 Apr 2008 07:38:59 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, ralf@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: Re: Pageflags: Standardize comment inclusion in asm-offsets.h and fix MIPS
Message-ID: <20080415053859.GA20813@uranus.ravnborg.org>
References: <Pine.LNX.4.64.0804141140430.7154@schroedinger.engr.sgi.com> <20080414133213.82a5b76e.akpm@linux-foundation.org> <Pine.LNX.4.64.0804141456410.8740@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0804141456410.8740@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2008 at 02:58:14PM -0700, Christoph Lameter wrote:
> On Mon, 14 Apr 2008, Andrew Morton wrote:
> 
> > afaict this change is not dependent upon the other page-flags changes and
> > can and should be merged ahead of the page-flags patches to preserve mips
> > bisectability, yes?
> 
> It could be merged before yes. There may be a conflict with the earlier 
> kbuild fixes though. Sam?

Please apply this. I am buried in day-time job atm so my
kbuild maintainer job is kept on loow priority.

	Sam
