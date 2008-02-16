Return-Path: <linux-kernel-owner+w=401wt.eu-S1756953AbYBPLDl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756953AbYBPLDl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 06:03:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751966AbYBPLDe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 06:03:34 -0500
Received: from twin.jikos.cz ([213.151.79.26]:40248 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751368AbYBPLDd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 06:03:33 -0500
Date: Sat, 16 Feb 2008 12:03:21 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Chris Holvenstot <cholvenstot@comcast.net>
cc: elendil@planet.nl, Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [2.6.25-rc1] jerky mouse cursor and randoooom key repeats
In-Reply-To: <1203123219.6176.36.camel@popeye>
Message-ID: <Pine.LNX.4.64.0802161202430.7699@twin.jikos.cz>
References: <1203123219.6176.36.camel@popeye>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Feb 2008, Chris Holvenstot wrote:

> A number of corrispondents on this list offered troubleshooting
> suggestions, most of which centered arund the high performance timer.
> If you too feel that the issue you are seeing might be releated to the
> one I saw the following clips from the email I received might be of
> interest to you.
> >From Jiri Kosina:
> It could be some timing problem. Does this happen also in console, or 
> only when running X?

Chris,

could you please check whether you have CONFIG_GROUP_SCHED turned on, and 
if so, try if turning it off fixes the problems?

-- 
Jiri Kosina
SUSE Labs

