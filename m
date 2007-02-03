Return-Path: <linux-kernel-owner+w=401wt.eu-S1751568AbXBCU3D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751568AbXBCU3D (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 15:29:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751575AbXBCU3C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 15:29:02 -0500
Received: from 1wt.eu ([62.212.114.60]:2235 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751568AbXBCU3A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 15:29:00 -0500
Date: Sat, 3 Feb 2007 21:28:57 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org
Subject: Re: Linux 2.4.34.1
Message-ID: <20070203202857.GF24090@1wt.eu>
References: <20070203201045.GA29991@hera.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070203201045.GA29991@hera.kernel.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 03, 2007 at 08:10:45PM +0000, Willy Tarreau wrote:
> 
> The files are located at the usual places. Please give it some time
> to sync between the servers, and preferably use ftp2.kernel.org.

I forgot to tell about the important part for GIT users. As Greg KH
recommended to me when I opened the 2.4-stable branch, I have created
separate trees for 2.4.33.y and 2.4.34.y. In order to make it easier
for people (and possibly automated scripts) to find those trees, Greg
and Chris accepted that I stored these trees close to theirs, in the
/pub/scm/linux/kernel/git/stable directory.

Unless someone stops me with a good reason (which I doubt), I will
soon remove the old 2.4-stable tree in my own GIT directory to
avoid confusing duplicates and to save disk space. However, standard
2.4 will stay there of course.

Regards,
Willy

