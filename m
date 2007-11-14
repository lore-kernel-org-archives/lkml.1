Return-Path: <linux-kernel-owner+w=401wt.eu-S1759566AbXKNPZu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759566AbXKNPZu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 10:25:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755689AbXKNPZm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 10:25:42 -0500
Received: from smurf.noris.de ([192.109.102.42]:48132 "EHLO smurf.noris.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755504AbXKNPZl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 10:25:41 -0500
X-Greylist: delayed 1498 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Nov 2007 10:25:41 EST
Date: Wed, 14 Nov 2007 15:59:38 +0100
To: Jiri Kosina <jikos@jikos.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc2-mm1
Message-ID: <20071114145938.GA5071@smurf.noris.de>
References: <20071113175906.497a1a6a.akpm@linux-foundation.org> <Pine.LNX.4.64.0711141538250.15844@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0711141538250.15844@twin.jikos.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Matthias Urlichs <smurf@smurf.noris.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Jiri Kosina:
> $ git-fetch git://git.kernel.org/pub/scm/linux/kernel/git/smurf/linux-trees.git tag v2.6.24-rc2-mm1
> error: no such remote ref refs/tags/v2.6.24-rc2-mm1

Yeah, the import took too long and thus broke.

Should be fixed by now.
-- 
Matthias Urlichs   |   {M:U} IT Design @ m-u-it.de   |  smurf@smurf.noris.de
Disclaimer: The quote was selected randomly. Really. | http://smurf.noris.de
 - -
:FTP: /F-T-P/, _not_ /fit'ip/ 1. [techspeak] n. The File Transfer
   Protocol for transmitting files between systems on the Internet. 2. vt.
   To {beam} a file using the File Transfer Protocol. 3. Sometimes used as
   a generic even for file transfers not using {FTP}. "Lemme get a copy of
   "Wuthering Heights" ftp'd from uunet."
