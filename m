Return-Path: <linux-kernel-owner+w=401wt.eu-S970336AbXILSZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970336AbXILSZ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 14:25:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S969256AbXILSZS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 14:25:18 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:38459 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967947AbXILSZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 14:25:16 -0400
Date: Wed, 12 Sep 2007 20:25:15 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Al Boldi <a1426z@gawab.com>
cc: hooanon05@yahoo.co.jp, bharata@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       hch@infradead.org, Jan Blunck <jblunck@suse.de>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: Re: [RFC] Union Mount: Readdir approaches
In-Reply-To: <200709121346.08364.a1426z@gawab.com>
Message-ID: <Pine.LNX.4.64.0709122024500.22467@fbirervta.pbzchgretzou.qr>
References: <20070907054618.GD1692@in.ibm.com> <200709071454.32451.a1426z@gawab.com>
 <E1ITdH3-0000sb-N4@jroun> <200709121346.08364.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 12 2007 13:46, Al Boldi wrote:
>hooanon05@yahoo.co.jp wrote:
>> But if you really want to read or try it, you can get all source files
>> from sourceforge. Read http://aufs.sf.net and try,
>> $ cvs -d:pserver:anonymous@aufs.cvs.sourceforge.net:/cvsroot/aufs login
>> (CVS password is empty)
>> $ cvs -z3 -d:pserver:anonymous@aufs.cvs.sourceforge.net:/cvsroot/aufs co
>> aufs
>
>This is way too complicated, but I tried it anyway, only to find it doesn't 
>compile:

cvs up -D 2007-08-07

that one works ;-)



	Jan
-- 
