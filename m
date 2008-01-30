Return-Path: <linux-kernel-owner+w=401wt.eu-S1761823AbYA3Sgy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761823AbYA3Sgy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 13:36:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754172AbYA3Sgo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 13:36:44 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:42664 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754142AbYA3Sgo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 13:36:44 -0500
Date: Wed, 30 Jan 2008 19:36:35 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Chris Holvenstot <cholvenstot@comcast.net>
Cc: Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [BUILD FAILURE] 2.6.24-git7 section type conflict at various drivers on powerpc
Message-ID: <20080130183635.GA25132@uranus.ravnborg.org>
References: <1201715851.7154.15.camel@popeye>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1201715851.7154.15.camel@popeye>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30, 2008 at 11:57:31AM -0600, Chris Holvenstot wrote:
> Please note that this does not appear to be just a issue with the
> powerpc build - I get the following failure whiole building a generic
> x86 2.6.24-git7 kernel.
> 
> drivers/net/sis190.c:329: error: sis190_pci_tbl causes a section type
> conflict

Jeff Garzik has already submitted a fix fr this pending merge.

	Sam
