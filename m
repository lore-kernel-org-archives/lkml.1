Return-Path: <linux-kernel-owner+w=401wt.eu-S1760971AbYEEUU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760971AbYEEUU3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 16:20:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756479AbYEEUUR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 16:20:17 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:58574 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754770AbYEEUUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 16:20:15 -0400
Date: Mon, 5 May 2008 22:21:04 +0200
From: Pavel Machek <pavel@suse.cz>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: kernel list <linux-kernel@vger.kernel.org>, kaszak@gmail.com,
       lcostantino@gmail.com, linux-wireless@vger.kernel.org
Subject: Re: w35und: some more code removal
Message-ID: <20080505202057.GB7273@elf.ucw.cz>
References: <20080505200927.GA7273@elf.ucw.cz> <1210018631.4181.29.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1210018631.4181.29.camel@johannes.berg>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2008-05-05 22:17:11, Johannes Berg wrote:
> On Mon, 2008-05-05 at 22:09 +0200, Pavel Machek wrote:
> > Remove some more unneccessary code
> > 
> > ---
> > commit 5b251c6315097d5f9ab5d30c43813fe74c1db4e4
> > tree 5ca21582f55886d5f0249f7ca139687450024581
> > parent e44ccdabb97fa4a6cdc1a95adcad7bcc469d0c16
> > author Pavel <pavel@amd.ucw.cz> Mon, 05 May 2008 22:08:51 +0200
> > committer Pavel <pavel@amd.ucw.cz> Mon, 05 May 2008 22:08:51 +0200
> 
> Let me guess, you're using git-am too? :P

No, this is actually all hand-generated ;-).
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
