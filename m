Return-Path: <linux-kernel-owner+w=401wt.eu-S1751478AbXBPKYJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751478AbXBPKYJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 05:24:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751497AbXBPKYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 05:24:09 -0500
Received: from scrub.xs4all.nl ([194.109.195.176]:54221 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751478AbXBPKYH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 05:24:07 -0500
Date: Fri, 16 Feb 2007 11:23:47 +0100 (CET)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Kumar Gala <galak@kernel.crashing.org>
cc: Sam Ravnborg <sam@ravnborg.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: kbuild question
In-Reply-To: <930B9C2E-DCE3-4E9E-AA6B-2C58E16736B2@kernel.crashing.org>
Message-ID: <Pine.LNX.4.64.0702161121540.14458@scrub.home>
References: <930B9C2E-DCE3-4E9E-AA6B-2C58E16736B2@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, 15 Feb 2007, Kumar Gala wrote:

> I was wondering if there was some way to make a Kconfig menu either be just a
> menu or a choice depending on another bool being set or not.
> 
> What I'm trying to accomplish is if CONFIG_ONLY_HAVE_ONE is set I want it so
> you can only select on option, however if CONFIG_ONLY_HAVE_ONE is not set you
> should be able to select multiple options.

Could you please be more specific about the problem you're trying to 
solve, instead of how you're trying to solve it?
A real example would help a lot to understand the actual problem.

bye, Roman
