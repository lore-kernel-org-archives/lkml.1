Return-Path: <linux-kernel-owner+w=401wt.eu-S932586AbZKDUzD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932586AbZKDUzD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 15:55:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932347AbZKDUzC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 15:55:02 -0500
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:38510 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932299AbZKDUzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 15:55:01 -0500
X-Greylist: delayed 2858 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Nov 2009 15:55:01 EST
Date: Wed, 4 Nov 2009 20:07:14 +0000
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Harald Arnesen <harald@skogtun.org>
Cc: Fabio Comolli <fabio.comolli@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #14372] ath5k wireless not working after rfkill [BISECTED]
Message-ID: <20091104200714.GA24699@sucs.org>
References: <Sj-rRjx6TwF.A.djE.vqe5KB@chimera> <6dRYo8ss7vL.A.xRH.vre5KB@chimera> <b637ec0b0910261315u43033948ge041cf70292bfa58@mail.gmail.com> <87aazddvft.fsf@basilikum.skogtun.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87aazddvft.fsf@basilikum.skogtun.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 27, 2009 at 10:42:46AM +0100, Harald Arnesen wrote:
> Fabio Comolli <fabio.comolli@gmail.com> writes:
> 
> > Still present in -rc5

Help. I've just bisected this down to the same commit
b56ab33d68638e6aafdbfc694025e8354a628f49 (that will teach me for not
reading the whole thread) as I have the same problem on my EeePC 900.

Still present in -rc6 and the latest git.

-- 
Sitsofe | http://sucs.org/~sits/
