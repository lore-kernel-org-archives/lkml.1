Return-Path: <linux-kernel-owner+w=401wt.eu-S1754781AbZGBTGb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781AbZGBTGb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 15:06:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753270AbZGBTGL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 15:06:11 -0400
Received: from wf-out-1314.google.com ([209.85.200.172]:37939 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897AbZGBTGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 15:06:10 -0400
Date: Thu, 2 Jul 2009 15:06:09 -0400 (EDT)
From: Jeff Arnold <jbarnold@ksplice.com>
X-X-Sender: jbarnold@vinegar-pot.mit.edu
To: Pavel Machek <pavel@ucw.cz>
cc: linux-kernel@vger.kernel.org, tabbott@ksplice.com, wdaher@ksplice.com,
       andersk@ksplice.com, nelhage@ksplice.com, price@ksplice.com,
       geofft@ksplice.com
Subject: Re: Ksplice updates for Ubuntu 9.04 Jaunty
In-Reply-To: <20090630063152.GC1351@ucw.cz>
Message-ID: <alpine.DEB.1.10.0907010909250.26501@vinegar-pot.mit.edu>
References: <alpine.DEB.1.10.0906250451210.22588@vinegar-pot.mit.edu> <20090630063152.GC1351@ucw.cz>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Jun 2009, Pavel Machek wrote:

> Hmmm, so what are its limits? How much manual work is involved?

The Ksplice technical paper (http://www.ksplice.com/paper) describes in 
detail how Ksplice works--including what it can do automatically and what 
requires assistance from a programmer or other tools.

> Lets say I want 2.6.30 -> 2.6.31-rc1... that's just source patch, right?

For now, we're using Ksplice to apply bug-fix patches, such as from the 
stable tree (2.6.29 -> 2.6.29.5, not 2.6.30 -> 2.6.31).

- Jeff
