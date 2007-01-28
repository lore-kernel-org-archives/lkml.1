Return-Path: <linux-kernel-owner+w=401wt.eu-S932912AbXA1Vsg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932912AbXA1Vsg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 16:48:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932914AbXA1Vsg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 16:48:36 -0500
Received: from mx1.redhat.com ([66.187.233.31]:53735 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932912AbXA1Vsf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 16:48:35 -0500
Date: Sun, 28 Jan 2007 16:48:32 -0500
From: Dave Jones <davej@redhat.com>
To: Thomas =?iso-8859-1?Q?Hellstr=F6m?= <thomas@tungstengraphics.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Support for i386 PATs
Message-ID: <20070128214832.GD23903@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Thomas =?iso-8859-1?Q?Hellstr=F6m?= <thomas@tungstengraphics.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <45BB1952.8000903@tungstengraphics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <45BB1952.8000903@tungstengraphics.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 27, 2007 at 10:20:18AM +0100, Thomas Hellström wrote:
 > Hi!
 > 
 > Does anybody have a strong opinion against adding support for
 > i386 Page Attribute Tables?

It pops up about once a year, everyone agrees it'd be a good idea,
and then nothing happens.  Last year, I started picking over
Terrence Ripperda's original implementation, but that needs a bit
of work. (http://lkml.org/lkml/2005/5/12/187)
Whoa, two years even.  Time flies.

		Dave

-- 
http://www.codemonkey.org.uk
