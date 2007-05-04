Return-Path: <linux-kernel-owner+w=401wt.eu-S1031288AbXEDE7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031288AbXEDE7U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 00:59:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031353AbXEDE7U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 00:59:20 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:29396 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031288AbXEDE7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 00:59:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=DL8ul+JoShDIuC+92iB8FQGxJ2SBe9gLPhbj3QdsksBeID/njK/rT16AzulpGGQ+YzMkCUxLdion0wdpFKOffhw3pDn+T5kVbyzut+nwqG5pyW0VJLxY7wZjkzdH28PfvQXp9nLUsrorP1v+2rIXi5sROb/KUgrwhxIbjdCNWmI=
Subject: Re: console font limits
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Daniel Hazelton <dhazelton@enter.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Kyle Moffett <mrmacman_g4@mac.com>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Albert Cahalan <acahalan@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, aeb@cwi.nl
In-Reply-To: <200705032358.56055.dhazelton@enter.net>
References: <787b0d920704302109r352e6653wc71a0638cbfbdcce@mail.gmail.com>
	 <E0FF8D28-219F-44D5-88B4-BDE6A4D6605A@mac.com> <463A80A9.7030809@zytor.com>
	 <200705032358.56055.dhazelton@enter.net>
Content-Type: text/plain
Date: Fri, 04 May 2007 12:59:07 +0800
Message-Id: <1178254748.4722.4.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-05-03 at 23:58 -0400, Daniel Hazelton wrote:
> On Thursday 03 May 2007 20:39:05 H. Peter Anvin wrote:
> > Kyle Moffett wrote:

> I guess I could start on that work again - shouldn't take me all that long to 
> recover the stuff I lost when a blackout caused my hard drive to get 
> corrupted beyond recovery (and the automated journal replay didn't do a 
> damned thing - I think it actually *added* to the corruption, but I don't 
> think any filesystem would have survived that)

You might want to look at the modesetting-101 branch of DRM.  It's goal
is similar to yours.  They even have a drm framebuffer.  I don't know
how far they are with their goal, but I can see some progress.

Here's their git tree:

git://git.freedesktop.org/git/mesa/drm#modesetting-101



