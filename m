Return-Path: <linux-kernel-owner+w=401wt.eu-S1030297AbXCGWat@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030297AbXCGWat (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 17:30:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030545AbXCGWat
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 17:30:49 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:38258 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030297AbXCGWas (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 17:30:48 -0500
Date: Wed, 7 Mar 2007 23:30:33 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Vivek Goyal <vgoyal@in.ibm.com>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Reloc Kernel List <fastboot@lists.osdl.org>, ebiederm@xmission.com,
       akpm@linux-foundation.org, ak@suse.de, hpa@zytor.com,
       magnus.damm@gmail.com, lwang@redhat.com, dzickus@redhat.com,
       rjw@sisk.pl
Subject: Re: [PATCH 10/20] x86_64: wakeup.S rename registers to reflect right names
Message-ID: <20070307223033.GA5956@elf.ucw.cz>
References: <20070307065703.GA23412@in.ibm.com> <20070307071200.GK23412@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070307071200.GK23412@in.ibm.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2007-03-07 12:42:00, Vivek Goyal wrote:
> 
> 
> o Use appropriate names for 64bit regsiters.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
> Signed-off-by: Vivek Goyal <vgoyal@in.ibm.com>

ACK.
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
