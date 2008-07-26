Return-Path: <linux-kernel-owner+w=401wt.eu-S1754194AbYGZCzo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754194AbYGZCzo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 22:55:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752616AbYGZCzg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 22:55:36 -0400
Received: from relay04.mail-hub.dodo.com.au ([123.2.6.239]:55401 "EHLO
	relay04.mail-hub.dodo.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752480AbYGZCzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 22:55:35 -0400
From: Grant Coady <grant_lkml@dodo.com.au>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [patch 0/9] 2.6.25-stable review
Date: Sat, 26 Jul 2008 12:54:14 +1000
Organization: http://bugsplatter.mine.nu/
Reply-To: Grant Coady <gcoady.lk@gmail.com>
Message-ID: <j74l84livfi260fi8glgpd09m9q7igqnu0@4ax.com>
References: <20080725230644.GA1612@suse.de>
In-Reply-To: <20080725230644.GA1612@suse.de>
X-Mailer: Forte Agent 2.0/32.652
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Jul 2008 16:06:44 -0700, Greg KH <gregkh@suse.de> wrote:

>This is the start of the stable review cycle for the 2.6.25.13 release.
>There are 9 patches in this series, all will be posted as a response to
>this one.  If anyone has any issues with these being applied, please let
>us know.  If anyone is a maintainer of the proper subsystem, and wants
>to add a Signed-off-by: line to the patch, please respond with it.
>
>These patches are sent out with a number of different people on the Cc:
>line.  If you wish to be a reviewer, please email stable@kernel.org to
>add your name to the list.  If you want to be off the reviewer list,
>also email us.
>
>Responses should be made by Monday, July 28, 12:00:00 UTC.  Anything
>received after that time might be too late.
>
>The whole patch series can be found in one patch at:
>	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.25.13-rc1.gz
>and the diffstat can be found below.

Being very brave or very silly, I put this on my firewall box due to the 
PPPoE changes, I run ADSL modem in bridge mode, not noticed any problems :)

Cheers,
Grant.
