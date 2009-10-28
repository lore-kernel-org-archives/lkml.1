Return-Path: <linux-kernel-owner+w=401wt.eu-S932791AbZJ1JFd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932791AbZJ1JFd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 05:05:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932747AbZJ1JFc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 05:05:32 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:33799 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932752AbZJ1JFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 05:05:31 -0400
Date: Wed, 28 Oct 2009 10:05:28 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Paulius Zaleckas <paulius.zaleckas@gmail.com>
Cc: Arve Hj?nnev?g <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Brian Swetland <swetland@google.com>, greg@kroah.com
Subject: Re: staging/dream: add gpio and pmem support
Message-ID: <20091028090528.GB18290@elf.ucw.cz>
References: <20091022091333.GA31023@elf.ucw.cz>
 <4AE807F8.2040909@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AE807F8.2040909@gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2009-10-28 10:59:36, Paulius Zaleckas wrote:
> On 10/22/2009 12:13 PM, Pavel Machek wrote:
> >
> >This adds generic_gpio and pmem support, both are needed for other
> >dream drivers.
> 
> Why you are not using existing gpiolib? That would make your driver a
> lot smaller and cleaner... and possibly with less bugs...

That can be cleaned up later.

> Why not split gpio and pmem into separate patches?

General overload? Can you help?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
