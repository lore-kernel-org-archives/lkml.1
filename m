Return-Path: <linux-kernel-owner+w=401wt.eu-S1765713AbXIMX1w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765713AbXIMX1w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 19:27:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757040AbXIMX1o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 19:27:44 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38404 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754016AbXIMX1n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 19:27:43 -0400
Date: Thu, 13 Sep 2007 19:27:36 -0400
From: Dave Jones <davej@redhat.com>
To: Chris Wedgwood <cw@f00f.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>,
       Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [RFC PATCH] Add a 'minimal tree install' target
Message-ID: <20070913232736.GA24962@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Chris Wedgwood <cw@f00f.org>, Sam Ravnborg <sam@ravnborg.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Eric Sandeen <sandeen@sandeen.net>
References: <20070912232534.GA26868@puku.stupidest.org> <20070913183359.GA27146@uranus.ravnborg.org> <20070913185753.GA9259@puku.stupidest.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070913185753.GA9259@puku.stupidest.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2007 at 11:57:53AM -0700, Chris Wedgwood wrote:
 
 
 > > I would like to attribute whoever made this somehow.
 > 
 > so would i, i assume it was davej + others so i cc'd him on this
 > hoping for feedback

90%+ of that part of the fedora specfile was Arjan's doings,
myself, dwmw2 and Jarod Wilson have poked at it since then,
but in mostly minor ways.

FWIW, I'd love to see this become a generic upstream target that
I could just use in the Fedora specfile.
The question I have is whether other distros do anything differently
that might be worth taking into consideration?

	Dave

-- 
http://www.codemonkey.org.uk
