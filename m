Return-Path: <linux-kernel-owner+w=401wt.eu-S1751848AbZHXIdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751848AbZHXIdR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 04:33:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751263AbZHXIdR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 04:33:17 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:37958 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244AbZHXIdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 04:33:16 -0400
X-Greylist: delayed 2345 seconds by postgrey-1.27 at vger.kernel.org; Mon, 24 Aug 2009 04:33:16 EDT
Date: Mon, 24 Aug 2009 09:55:23 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: Joonwoo Park <joonwpark81@gmail.com>
Cc: Linux PPS <linuxpps@ml.enneenne.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Message-ID: <20090824075523.GB9417@gundam.enneenne.com>
Mail-Followup-To: Joonwoo Park <joonwpark81@gmail.com>,
	Linux PPS <linuxpps@ml.enneenne.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <4A89813A.4060603@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A89813A.4060603@gmail.com>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 192.168.32.254
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCH] pps: fix incorrect verdict check
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 17, 2009 at 09:11:38AM -0700, Joonwoo Park wrote:
> From: Joonwoo Park <joonwpark81@gmail.com>
>
> Fix incorrect verdict check and returns error if device_create failed,
> otherwise driver triggers kernel oops.
>
> Signed-off-by: Joonwoo Park<joonwpark81@gmail.com>

Acked-by: Rodolfo Giometti <giometti@linux.it>

-- 

GNU/Linux Solutions                  e-mail: giometti@enneenne.com
Linux Device Driver                          giometti@linux.it
Embedded Systems                     phone:  +39 349 2432127
UNIX programming                     skype:  rodolfo.giometti
Freelance ICT Italia - Consulente ICT Italia - www.consulenti-ict.it
