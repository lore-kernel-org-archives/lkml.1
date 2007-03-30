Return-Path: <linux-kernel-owner+w=401wt.eu-S1753922AbXC3Qfk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922AbXC3Qfk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 12:35:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753915AbXC3Qfk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 12:35:40 -0400
Received: from csclub1.cs.uwaterloo.ca ([129.97.7.226]:34769 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753914AbXC3Qfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 12:35:39 -0400
Date: Fri, 30 Mar 2007 12:35:38 -0400
To: Andrei Popa <andrei.popa@i-neo.ro>
Cc: Jesse Brandeburg <jesse.brandeburg@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       NetDEV list <netdev@vger.kernel.org>
Subject: Re: [BUG] ethX misnumbered and one missing in mii-tool
Message-ID: <20070330163538.GC3510@csclub.uwaterloo.ca>
References: <1175203383.6219.8.camel@localhost> <4807377b0703292121o6eef3bf2l998878cfd677d821@mail.gmail.com> <1175240543.6219.10.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1175240543.6219.10.camel@localhost>
User-Agent: Mutt/1.5.9i
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 30, 2007 at 10:42:23AM +0300, Andrei Popa wrote:
> ethtool reports the same

Is udev running and having fun renumbering interfaces as they are being
detected in order to keep "consistent" interface names?

--
Len Sorensen
