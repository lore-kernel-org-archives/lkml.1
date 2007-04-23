Return-Path: <linux-kernel-owner+w=401wt.eu-S1751704AbXDWOEJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751704AbXDWOEJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 10:04:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753971AbXDWOEI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 10:04:08 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:36616 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704AbXDWOEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 10:04:07 -0400
Subject: Re: Testing framework
From: Avishay Traeger <atraeger@cs.sunysb.edu>
To: Karuna sagar K <karunasagark@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <2e4afe1e0704221346u6d6baec1uab88dc273ff08de9@mail.gmail.com>
References: <2e4afe1e0704221346u6d6baec1uab88dc273ff08de9@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 23 Apr 2007 10:04:00 -0400
Message-Id: <1177337041.3704.4.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-04-23 at 02:16 +0530, Karuna sagar K wrote:
> For some time I had been working on this file system test framework.
> Now I have a implementation for the same and below is the explanation.
> Any comments are welcome.

<snip>

You may want to check out the paper "EXPLODE: A Lightweight, General
System for Finding Serious Storage System Errors" from OSDI 2006 (if you
haven't already).  The idea sounds very similar to me, although I
haven't read all the details of your proposal.

Avishay

