Return-Path: <linux-kernel-owner+w=401wt.eu-S1759344AbYAXWJi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759344AbYAXWJi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 17:09:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756419AbYAXWJa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 17:09:30 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:52473 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753395AbYAXWJ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 17:09:29 -0500
Date: Thu, 24 Jan 2008 23:09:39 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: kbuild: Preparing for merge window
Message-ID: <20080124220939.GC4204@uranus.ravnborg.org>
References: <20080124215813.GA4204@uranus.ravnborg.org> <20080124140422.409555b9.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080124140422.409555b9.randy.dunlap@oracle.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, 2008 at 02:04:22PM -0800, Randy Dunlap wrote:
> On Thu, 24 Jan 2008 22:58:13 +0100 Sam Ravnborg wrote:
> 
> > The following is the list of patches queued up for the merge window at the moment.
> > I have during the last week done several modpost changes to make section ismatch
> > warnings more reliable and I am happy with the modified modpost code now.
> 
> 
> Hi Sam,
> 
> Can you add (if not already done) a paragraph to kconfig-language.txt
> about the preference of using HAVE_feature in Kconfig files vs.
> other spellings of that?

Thanks for the reminder - will do it over the weekend.

	Sam
