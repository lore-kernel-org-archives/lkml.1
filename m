Return-Path: <linux-kernel-owner+w=401wt.eu-S1752646AbYAXO13@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646AbYAXO13 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 09:27:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751699AbYAXO1T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 09:27:19 -0500
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:48277 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751668AbYAXO1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 09:27:18 -0500
Date: Thu, 24 Jan 2008 09:27:17 -0500
To: Marcin Gil <marcin.gil@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: JMicron PATA 2.6.24-rc7 can't find drives
Message-ID: <20080124142717.GA16173@csclub.uwaterloo.ca>
References: <200801232323.36187.marcin.gil@gmail.com> <20080123234639.025cc859@lxorguk.ukuu.org.uk> <479839B4.3060202@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <479839B4.3060202@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, 2008 at 08:09:40AM +0100, Marcin Gil wrote:
> Here it is:
> http://pastebin.com/md726431

Line 416 looks like it detected the DVD.

Look for /dev/scd0 or /dev/sr0 or if using a decent udev setup perhaps
even /dev/dvdrw.

--
Len Sorensen
