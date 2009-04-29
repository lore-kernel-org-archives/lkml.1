Return-Path: <linux-kernel-owner+w=401wt.eu-S932394AbZD2CMe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932394AbZD2CMe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 22:12:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757713AbZD2CMY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 22:12:24 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:36792 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755162AbZD2CMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 22:12:23 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH RFC] ext3 data=guarded v5
Cc: kosaki.motohiro@jp.fujitsu.com, Jan Kara <jack@suse.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Theodore Ts'o" <tytso@mit.edu>,
       Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
       Ext4 Developers List <linux-ext4@vger.kernel.org>,
       Mike Galbraith <efault@gmx.de>
In-Reply-To: <1240941840.15136.44.camel@think.oraclecorp.com>
References: <1240941840.15136.44.camel@think.oraclecorp.com>
Message-Id: <20090429110828.4B08.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Wed, 29 Apr 2009 11:12:18 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi 

> Hello everyone,
> 
> I've rediffed the ext3 data=guarded code against Linus' current git
> tree, and worked in most of Jan's suggestions:

I'm not fs expert and I can't review it technically. but please don't
use the name of "guarded". this word implies strong protection. 

I think end-user can misunderstand this mode make slowness and strong protect
much than "mode=journal".



