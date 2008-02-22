Return-Path: <linux-kernel-owner+w=401wt.eu-S1761406AbYBVQ7R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761406AbYBVQ7R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 11:59:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757815AbYBVQ64
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 11:58:56 -0500
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:3529 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753981AbYBVQ6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 11:58:55 -0500
Subject: Re: [RFC/PATCH] Update coding standard to avoid ungrepable printk
	format strings
From: Joe Perches <joe@perches.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, torvalds@osdl.org, git <git@vger.kernel.org>
In-Reply-To: <20080222132612.GA11717@basil.nowhere.org>
References: <20080222132612.GA11717@basil.nowhere.org>
Content-Type: text/plain
Date: Fri, 22 Feb 2008 08:58:30 -0800
Message-Id: <1203699510.19319.56.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0-2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-02-22 at 14:26 +0100, Andi Kleen wrote:
> RFC: Update coding standard to avoid split up printk format strings

Perhaps it's more useful to have git become more content aware.

If git could track user specified file glob pattern ("*.[ch]$")
changes by statement terminator (";") and git could format
output by a user specified pass (lindent), many of the bike shed
paint discussions and a lot of commits would never occur.


