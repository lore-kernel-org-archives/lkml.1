Return-Path: <linux-kernel-owner+w=401wt.eu-S1754875AbYAXOoQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754875AbYAXOoQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 09:44:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752154AbYAXOoD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 09:44:03 -0500
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:44579 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751749AbYAXOoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 09:44:00 -0500
Date: Thu, 24 Jan 2008 09:43:59 -0500
To: Marcin Gil <marcin.gil@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: JMicron PATA 2.6.24-rc7 can't find drives
Message-ID: <20080124144359.GD16171@csclub.uwaterloo.ca>
References: <200801232323.36187.marcin.gil@gmail.com> <20080123234639.025cc859@lxorguk.ukuu.org.uk> <479839B4.3060202@gmail.com> <20080124142717.GA16173@csclub.uwaterloo.ca> <4798A114.6010803@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4798A114.6010803@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, 2008 at 03:30:44PM +0100, Marcin Gil wrote:
> This is not a problem. I've posted (in original mail) that DVD is found 
> fine (and linked as /dev/cdrom). But I have a Maxtor HDD on the same 
> ide-tape and it is not detected at all.

Are you using an 80 pin IDE cable and are both drives set to cable
select (usually preferable) or is one master and one slave?

--
Len Sorensen
