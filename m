Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752224Ab0BHXJE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 18:09:04 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60504 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751557Ab0BHXJA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 18:09:00 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: davidsen@tmr.com
Subject: Re: 2.6.33-rc6 crashes on resume
Date: Tue, 9 Feb 2010 00:09:50 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc7-rjw; KDE/4.3.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <4B70982F.8090208@roadwarrior3.tmr.com>
In-Reply-To: <4B70982F.8090208@roadwarrior3.tmr.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201002090009.50118.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 February 2010, Bill Davidsen wrote:
> Pretty simple to reproduce, boot, suspend, press shift
> 
> Acer Aspire 1681, Celeron, 2.6.33-rc6. Trace and config attached.

I guess 2.6.32 didn't crash?

Rafael
