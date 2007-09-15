Return-Path: <linux-kernel-owner+w=401wt.eu-S1755234AbXIOOUZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234AbXIOOUZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 10:20:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752300AbXIOOUK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 10:20:10 -0400
Received: from quail.cita.utoronto.ca ([128.100.76.6]:45661 "EHLO
	quail.cita.utoronto.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbXIOOUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 10:20:08 -0400
X-Greylist: delayed 1396 seconds by postgrey-1.27 at vger.kernel.org; Sat, 15 Sep 2007 10:20:08 EDT
Date: Sat, 15 Sep 2007 09:56:33 -0400
From: Robin Humble <rjh@cita.utoronto.ca>
To: Jeff Garzik <jeff@garzik.org>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: Distributed storage. Move away from char device ioctls.
Message-ID: <20070915135633.GA19482@lemming.cita.utoronto.ca>
References: <20070914185429.GA9439@2ka.mipt.ru> <46EADC02.9070409@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46EADC02.9070409@garzik.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2007 at 03:07:46PM -0400, Jeff Garzik wrote:
>It is my hope that you will put your skills towards a distributed 
>filesystem :)  Of the current solutions, GFS (currently in kernel) 
>scales poorly, and NFS v4.1 is amazingly bloated and overly complex.
>
>I've been waiting for years for a smart person to come along and write a 
>POSIX-only distributed filesystem.

it's called Lustre.
works well, scales well, is widely used, is GPL.
sadly it's not in mainline.

cheers,
robin
