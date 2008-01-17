Return-Path: <linux-kernel-owner+w=401wt.eu-S1757482AbYAQWLq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757482AbYAQWLq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 17:11:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753042AbYAQWLj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 17:11:39 -0500
Received: from 1wt.eu ([62.212.114.60]:1394 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752843AbYAQWLi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 17:11:38 -0500
Date: Thu, 17 Jan 2008 22:48:36 +0100
From: Willy Tarreau <w@1wt.eu>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Adrian Bunk <bunk@kernel.org>, Jiri Kosina <jikos@jikos.cz>,
       linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.16.58
Message-ID: <20080117214836.GG8953@1wt.eu>
References: <20080115221832.GA4449@does.not.exist> <Pine.LNX.4.64.0801161703190.15647@twin.jikos.cz> <20080117203416.GK23696@does.not.exist> <20080117211205.GE8953@1wt.eu> <20080117214755.GB28233@does.not.exist> <20080117213225.GF8953@1wt.eu> <20080117220219.GA22980@khazad-dum.debian.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080117220219.GA22980@khazad-dum.debian.net>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2008 at 08:02:19PM -0200, Henrique de Moraes Holschuh wrote:
> Err... I managed to do it for thinkpad-acpi's merge tree too, a lot of time
> ago.  So it was somehow possible to get it through the anonymous git server,
> probably through the tag.  What I do know is that I usually send head's up
> email when I notice something like this, and I find it strange that you
> didn't get one from me at that time... but I may have forgotten to send it
> at that time.

Well, since there are commands that work on this (push and log at
least), I believe that some operations could succeed. I *know* that
remote cloning was impossible, and it *looked* like pulling too was
during my attempts to fix the problem before understanding its root
cause. It is possible that I cumulated problems though, if at least
two people could pull from it.

Cheers,
Willy

