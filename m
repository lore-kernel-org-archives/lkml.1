Return-Path: <linux-kernel-owner+w=401wt.eu-S1760341AbYEPQmE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760341AbYEPQmE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 12:42:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759464AbYEPQfp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 12:35:45 -0400
Received: from vena.lwn.net ([206.168.112.25]:52604 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758956AbYEPQfo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 12:35:44 -0400
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Tracking and crediting bug reporters 
From: corbet@lwn.net (Jonathan Corbet)
In-reply-to: Your message of "Tue, 13 May 2008 13:28:49 +0300."
             <20080513102849.GB25196@cs181133002.pp.htv.fi> 
Date: Fri, 16 May 2008 10:35:43 -0600
Message-ID: <18918.1210955743@vena.lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Operating in delayed response mode, sorry...]

Adrian Bunk <bunk@kernel.org> wrote:

> In which format do you want data for commits already in 2.6.26?

I hadn't thought about trying to backfill data for existing commits;
that sounds like a fair amount of work for coverage which could still be
somewhat spotty.  If you have the data at hand, though, then a simple
file of the form

	commit-id  full-name <email>

could be dealt with.  But is it really worth the effort?

Thanks,

jon
