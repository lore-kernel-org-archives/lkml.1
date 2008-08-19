Return-Path: <linux-kernel-owner+w=401wt.eu-S1755215AbYHSP4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755215AbYHSP4V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 11:56:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751898AbYHSP4M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 11:56:12 -0400
Received: from adsl-67-120-171-161.dsl.lsan03.pacbell.net ([67.120.171.161]:38366
	"HELO linuxace.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751125AbYHSP4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 11:56:11 -0400
Date: Tue, 19 Aug 2008 08:56:10 -0700
From: Phil Oester <kernel@linuxace.com>
To: Hinko Kocevar <hinko.kocevar@cetrtapot.si>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: iptables-1.4.0 with 2.6.26
Message-ID: <20080819155610.GC13246@linuxace.com>
References: <48AAAFEB.8020608@cetrtapot.si> <20080819140601.GA5135@linuxace.com> <48AAD48E.3030409@cetrtapot.si> <20080819152504.GA13246@linuxace.com> <48AAE7A5.9000902@cetrtapot.si>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48AAE7A5.9000902@cetrtapot.si>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2008 at 05:32:53PM +0200, Hinko Kocevar wrote:
> > Please run make install, then it will work for you from the install directory.
> 
> Will this be a problem on an embedded system, when iptables are cross compiled? 
> Are there some cynimic libraries that are pulled in from somewhere (probably destdir installation dir)?

Well, if you use the non-static version, then you need the various .so files - 
see /lib/xtables/lib*.

Phil
