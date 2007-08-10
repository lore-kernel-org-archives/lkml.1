Return-Path: <linux-kernel-owner+w=401wt.eu-S1759614AbXHJAJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759614AbXHJAJU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 20:09:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754815AbXHJAJG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 20:09:06 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56785 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754452AbXHJAJF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 20:09:05 -0400
Date: Thu, 9 Aug 2007 20:09:00 -0400
From: Dave Jones <davej@redhat.com>
To: shacky <shacky83@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Unable to handle kernel paging request at virtual address
Message-ID: <20070810000900.GA30952@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	shacky <shacky83@gmail.com>, linux-kernel@vger.kernel.org
References: <7fedbc910708091617o7ae25fd8i36e7ec32c2b9ba86@mail.gmail.com> <20070809234000.GA19549@redhat.com> <7fedbc910708091644u5aaf37f7q5d259a66e2a4cce8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7fedbc910708091644u5aaf37f7q5d259a66e2a4cce8@mail.gmail.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 10, 2007 at 01:44:24AM +0200, shacky wrote:
 > > You snipped the most important part.  Even a digital photo of the
 > > crash would be more useful than what we have above.
 > > So far, there's not really much to go on.
 > 
 > Could you tell me what is the most important part, so I try to rewrite
 > it by hand?

It's hard to blindly guess because there's so little to go on.
At the least, a complete list of the modules loaded, the EIP/RIP
and the call trace. (This makes up 90% of the output, hence the
suggestion to take a photograph).

 > I don't think a digital photo will be much useful because the whole
 > error is writed on a simple black screen with white caracters.

That's expected. We usually cope with that quite well.

	Dave

-- 
http://www.codemonkey.org.uk
