Return-Path: <linux-kernel-owner+w=401wt.eu-S1760326AbYBWBo6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760326AbYBWBo6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 20:44:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754267AbYBWBos
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 20:44:48 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:36251 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754021AbYBWBor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 20:44:47 -0500
Date: Sat, 23 Feb 2008 01:44:45 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Chase Venters <chase.venters@clientec.com>, linux-kernel@vger.kernel.org,
       git@vger.kernel.org
Subject: Re: Question about your git habits
Message-ID: <20080223014445.GK27894@ZenIV.linux.org.uk>
References: <200802221837.37680.chase.venters@clientec.com> <Pine.LNX.4.64.0802230221140.21077@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0802230221140.21077@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 23, 2008 at 02:37:00AM +0100, Jan Engelhardt wrote:

> >do you tend to clone the entire repository repeatedly into a series
> >of separate working directories
> 
> Too time consuming on consumer drives with projects the size of Linux.

git clone -l -s

is not particulary slow...
