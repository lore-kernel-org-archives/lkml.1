Return-Path: <linux-kernel-owner+w=401wt.eu-S1756805AbZAJPBy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756805AbZAJPBy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 10:01:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754940AbZAJPBq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 10:01:46 -0500
Received: from casper.infradead.org ([85.118.1.10]:45057 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583AbZAJPBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 10:01:45 -0500
Subject: Re: [Regression] Build failure in current mainline - firmware
 related
From: David Woodhouse <dwmw2@infradead.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       "Igor M. Liplianin" <liplianin@me.by>,
       Mauro Carvalho Chehab <mchehab@redhat.com>
In-Reply-To: <1231598216.5806.124.camel@macbook.infradead.org>
References: <200901031247.14977.rjw@sisk.pl>
	 <20090103204948.GA5388@uranus.ravnborg.org>
	 <20090103205437.GA5499@uranus.ravnborg.org>
	 <200901032243.28684.rjw@sisk.pl>
	 <20090104214406.GA31668@uranus.ravnborg.org>
	 <1231598216.5806.124.camel@macbook.infradead.org>
Content-Type: text/plain
Date: Sat, 10 Jan 2009 14:58:18 +0000
Message-Id: <1231599498.5806.125.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 (2.24.2-2.fc10) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-01-10 at 14:37 +0000, David Woodhouse wrote:
> Rafael, if you revert Sam's fix and also revert 4b29631d, does it work
> again?

The firmware-2.6.git tree now contains what I suggest; please confirm
that it's fixed (again).

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

