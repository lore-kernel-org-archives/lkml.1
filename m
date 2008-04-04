Return-Path: <linux-kernel-owner+w=401wt.eu-S1757324AbYDDBkr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757324AbYDDBkr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 21:40:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751970AbYDDBkh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 21:40:37 -0400
Received: from relay1.sgi.com ([192.48.171.29]:49153 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750928AbYDDBkh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 21:40:37 -0400
Date: Thu, 3 Apr 2008 18:37:57 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Toralf Foerster <toralf.foerster@gmx.de>
Subject: Re: slub compile error
In-Reply-To: <pdYe6zNQVl.A.kR.5DW9HB@albercik>
Message-ID: <Pine.LNX.4.64.0804031836270.10635@schroedinger.engr.sgi.com>
References: <pdj7pZVURbL.A.42H.kDW9HB@albercik> <pdYe6zNQVl.A.kR.5DW9HB@albercik>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Apr 2008, Rafael J. Wysocki wrote:

> The following report is on the current list of known regressions
> from 2.6.24.  Please verify if the issue is still present in the
> mainline.

The bug was not in 2.6.24. It was introduced a couple of days 
before 2.6.25-rc8 and the fix was the last commit added before rc8 was 
released.
