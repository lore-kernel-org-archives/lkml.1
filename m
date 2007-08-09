Return-Path: <linux-kernel-owner+w=401wt.eu-S1755409AbXHITak@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409AbXHITak (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 15:30:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751865AbXHITad
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 15:30:33 -0400
Received: from one.firstfloor.org ([213.235.205.2]:57476 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539AbXHITac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 15:30:32 -0400
Date: Thu, 9 Aug 2007 21:30:31 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Francois Romieu <romieu@fr.zoreil.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       =?iso-8859-1?Q?Hans-J=FCrgen?= Koch <hjk@linutronix.de>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: Documentation files in html format?
Message-ID: <20070809193031.GB32280@one.firstfloor.org>
References: <20070809113122.3aa508e4@oldman.hamilton.local> <200708091508.20626.hjk@linutronix.de> <p73hcn8g25m.fsf@bingen.suse.de> <20070809191036.GA23596@electric-eye.fr.zoreil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070809191036.GA23596@electric-eye.fr.zoreil.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> xsltproc converts from docbook to html fast enough (PDF with a docbook

I don't think that is used by Linuxdoc. Try a make pdfdocs and see
for yourself.

-Andi
