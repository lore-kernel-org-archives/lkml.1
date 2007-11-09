Return-Path: <linux-kernel-owner+w=401wt.eu-S1754592AbXKJTxr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592AbXKJTxr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 14:53:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753057AbXKJTxk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 14:53:40 -0500
Received: from belushi.uits.indiana.edu ([129.79.1.188]:47518 "EHLO
	belushi.uits.indiana.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752966AbXKJTxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 14:53:39 -0500
From: CSights <csights@fastmail.fm>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: cannot "hibernate" if program being debugged in gdb is paused after SIGABRT in linux 2.6.23 (but can in 2.6.22.7)
Date: Fri, 9 Nov 2007 08:30:03 -0500
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
References: <200710252103.27675.csights@fastmail.fm> <200710301034.08268.csights@fastmail.fm> <200711082350.52010.rjw@sisk.pl>
In-Reply-To: <200711082350.52010.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711090830.03115.csights@fastmail.fm>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

> Can you please check if you are able to reproduce the problem with
> 2.6.24-rc2?

	I am not able to reproduce the problem with 2.6.24-rc2.  I am able to suspend 
to disk successfully.

Thank for the prompt fix! :)
	C.
