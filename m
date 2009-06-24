Return-Path: <linux-kernel-owner+w=401wt.eu-S1757445AbZFXSNj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757445AbZFXSNj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 14:13:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751666AbZFXSNb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 14:13:31 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:37259 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071AbZFXSNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 14:13:31 -0400
Date: Wed, 24 Jun 2009 20:13:24 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Vitaly Minko <vitaly.minko@gmail.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>
Subject: Re: 2.6.30 kernel for Zaurus
Message-ID: <20090624181323.GC6618@elf.ucw.cz>
References: <4A4227D7.4050900@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A4227D7.4050900@gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed 2009-06-24 17:19:19, Vitaly Minko wrote:
> Hi Pavel,
>
> I want to upgrade my kernel on Zaurus C1000 to the latest stable version.
> Do I need any additional patches besides your suspend-related one that  
> you posted here:
> http://patchwork.kernel.org/patch/26927/

Well, you'll also need to disable offline charging, and I only tested
it on spitz.
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
