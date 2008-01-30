Return-Path: <linux-kernel-owner+w=401wt.eu-S932954AbYA3UYf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932954AbYA3UYf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 15:24:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755294AbYA3UYZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 15:24:25 -0500
Received: from qmta04.emeryville.ca.mail.comcast.net ([76.96.30.40]:57841 "EHLO
	QMTA04.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751165AbYA3UYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 15:24:24 -0500
X-Authority-Analysis: v=1.0 c=1 a=EouV8EeEjs0A:10 a=VfySWKbnecVx6JACc3AA:9
 a=TDQ70N-jsfa6wcRGu6f5ouehjHYA:4 a=-ZQhYGXY2L8A:10
Subject: Re: [BUILD FAILURE] 2.6.24-git7 section type conflict at various
	drivers on powerpc
From: Chris Holvenstot <cholvenstot@comcast.net>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20080130183635.GA25132@uranus.ravnborg.org>
References: <1201715851.7154.15.camel@popeye>
	 <20080130183635.GA25132@uranus.ravnborg.org>
Content-Type: text/plain
Date: Wed, 30 Jan 2008 14:27:14 -0600
Message-Id: <1201724835.28365.1.camel@popeye>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For what it is worth - noted that 2.6.24-git8 now available - same error
as git7.  


On Wed, 2008-01-30 at 19:36 +0100, Sam Ravnborg wrote:
> On Wed, Jan 30, 2008 at 11:57:31AM -0600, Chris Holvenstot wrote:
> > Please note that this does not appear to be just a issue with the
> > powerpc build - I get the following failure whiole building a generic
> > x86 2.6.24-git7 kernel.
> > 
> > drivers/net/sis190.c:329: error: sis190_pci_tbl causes a section type
> > conflict
> 
> Jeff Garzik has already submitted a fix fr this pending merge.
> 
> 	Sam

