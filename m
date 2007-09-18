Return-Path: <linux-kernel-owner+w=401wt.eu-S1756521AbXIRSKV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756521AbXIRSKV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 14:10:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753137AbXIRSKI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 14:10:08 -0400
Received: from sslsrv.de ([62.75.159.123]:59665 "EHLO sslsrv.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752411AbXIRSKG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 14:10:06 -0400
From: Philipp Marek <philipp@marek.priv.at>
To: Jeff Dike <jdike@addtoit.com>
Subject: Re: UML dead with current -git?
Date: Tue, 18 Sep 2007 20:09:52 +0200
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
References: <200709181714.34035@x5> <20070918171313.GA6591@c2.user-mode-linux.org>
In-Reply-To: <20070918171313.GA6591@c2.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709182009.53119@x5>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 18 September 2007 Jeff Dike wrote:
> On Tue, Sep 18, 2007 at 05:14:33PM +0200, Philipp Marek wrote:
> > I'm trying to build a UML machine on x86-64 (config attached)
> > but I'm getting compile errors.
>
> Builds for me.  Did you start with an mrproper?  These errors look
> like the UML build getting confused by left-overs from an x86_64
> build.
No, I didn't. Shouldn't that get cleaned up by a (completely new) config 
anyway?

I'll try and tell you tomorrow.


Thank you!


Regards,

Phil


-- 
Versioning your /etc, /home or even your whole installation?
             Try fsvs (fsvs.tigris.org)!
