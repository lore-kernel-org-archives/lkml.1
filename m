Return-Path: <linux-kernel-owner+w=401wt.eu-S1752326AbZCKITT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752326AbZCKITT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 04:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751223AbZCKITG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 04:19:06 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56915 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077AbZCKITF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 04:19:05 -0400
Date: Wed, 11 Mar 2009 09:18:54 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Hannes Eder <hannes@hanneseder.net>
Cc: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] checkpatch: make -f alias --file, add --help, more
	verbose help message
Message-ID: <20090311081854.GA1533@ucw.cz>
References: <20090112092839.GA2190@elf.ucw.cz> <496B0E5F.1020902@tremplin-utc.net> <20090116121940.GA30302@elf.ucw.cz> <20090116143404.ccf2d9ee.akpm@linux-foundation.org> <20090120103219.GK2576@elf.ucw.cz> <20090310172026.10948.10453.stgit@f10box.hanneseder.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090310172026.10948.10453.stgit@f10box.hanneseder.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2009-03-10 18:21:23, Hannes Eder wrote:
> Impact:
>   - More verbose help/usage message.
>   - Make the option -f an alias for --file.
>   - On -h, --help, and --version display help message and exit(0).
>   - With no FILE(s) given, exit(1) with "no input files".
>   - On invalid options display help/usage and exit(1).
> 
> Based on a patch by Pavel Machek.
> 
> Signed-off-by: Hannes Eder <hannes@hanneseder.net>
> Cc: Pavel Machek <pavel@suse.cz>


ACK and thanks...

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
