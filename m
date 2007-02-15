Return-Path: <linux-kernel-owner+w=401wt.eu-S932737AbXBONWo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932737AbXBONWo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 08:22:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932739AbXBONWo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 08:22:44 -0500
Received: from 81-174-11-161.f5.ngi.it ([81.174.11.161]:57711 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932737AbXBONWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 08:22:43 -0500
Date: Thu, 15 Feb 2007 14:23:01 +0100
From: Rodolfo Giometti <giometti@enneenne.com>
To: James Simmons <jsimmons@infradead.org>
Cc: linux-kernel@vger.kernel.org
Message-ID: <20070215132300.GM8882@enneenne.com>
References: <20070213173805.GK8882@enneenne.com> <20070213174829.GA465@flint.arm.linux.org.uk> <20070213180456.GL8882@enneenne.com> <Pine.LNX.4.64.0702131821020.6679@pentafluge.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702131821020.6679@pentafluge.infradead.org>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCH] pxafb: Add option to enable/disable the cursor
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 13, 2007 at 06:22:01PM +0000, James Simmons wrote:
> 
> The reason you have a cursor is because you are using the framebuffer 
> console. Do you need fbcon ? 

Yes. During the system update process on in the production stage a
console is very useful.

Ciao,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@gnudd.com
Embedded Systems                     		giometti@linux.it
UNIX programming                     phone:     +39 349 2432127
