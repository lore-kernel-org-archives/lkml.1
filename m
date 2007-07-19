Return-Path: <linux-kernel-owner+w=401wt.eu-S965741AbXGSTL6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965741AbXGSTL6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 15:11:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935406AbXGSTLF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 15:11:05 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:54026 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764986AbXGSTLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 15:11:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=WttX6DzIPGl4Uh05cT2/xH2vSkJou/AcVGdzmUVtOIJGlx41pD6YYmUljeQQWNpW3sN7tkwedVEc42cslum1MA2enSBeE2m2Qjjs7AQecN+z1ZMVpzMMtGD7Lp0fywtQc4YYFhZQT5Uy30GwOC+6Xc1WHIBZ39fOmoXqJ8WOd/s=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: Re: [2/2] 2.6.22-git: known regressions
Date: Thu, 19 Jul 2007 21:27:06 +0200
User-Agent: KMail/1.9.6
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>,
       Theodore Tso <tytso@mit.edu>, linux-fsdevel@vger.kernel.org,
       Mingming Cao <cmm@us.ibm.com>, Doug Chapman <doug.chapman@hp.com>,
       Vasily Tarasov <vtaras@openvz.org>, linux-ide@vger.kernel.org,
       Kumar Gala <galak@kernel.crashing.org>, linuxppc-dev@ozlabs.org,
       Christoph Lameter <clameter@sgi.com>, Andi Kleen <ak@suse.de>,
       Greg Kroah-Hartman <gregkh@suse.de>, Jean Delvare <khali@linux-fr.org>,
       Tejun Heo <htejun@gmail.com>
References: <469F9125.8040502@googlemail.com> <469F92AF.10405@googlemail.com>
In-Reply-To: <469F92AF.10405@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707192127.07238.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 July 2007, Michal Piotrowski wrote:

> IDE
> 
> Subject         : compile error if CONFIG_BLOCK not enabled related to linux/ide.h include
> References      : http://lkml.org/lkml/2007/7/18/11
> Last known good : ?
> Submitter       : Kumar Gala <galak@kernel.crashing.org>
> Caused-By       : ?
> Handled-By      : Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Status          : unknown

Not a 2.6.22-git regression (CONFIG_BLOCK was added on September 2006) and
Kumar should have a fix really soon - could be removed from the list IMO.

Thanks,
Bart
