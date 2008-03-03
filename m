Return-Path: <linux-kernel-owner+w=401wt.eu-S1751384AbYCCWVk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751384AbYCCWVk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 17:21:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759910AbYCCWV1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 17:21:27 -0500
Received: from mx1.redhat.com ([66.187.233.31]:43483 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752146AbYCCWV0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 17:21:26 -0500
Date: Mon, 3 Mar 2008 17:21:18 -0500
From: Rik van Riel <riel@redhat.com>
To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
Cc: "Christian Kujau" <lists@nerdbynature.de>,
       "Linux kernel" <linux-kernel@vger.kernel.org>
Subject: Re: 64-bit AMD panic
Message-ID: <20080303172118.2ee4fa75@cuia.boston.redhat.com>
In-Reply-To: <Pine.LNX.4.61.0803031704290.7011@chaos.analogic.com>
References: <Pine.LNX.4.61.0803031205030.5874@chaos.analogic.com>
	<alpine.DEB.1.00.0803031942040.5974@sheep.housecafe.de>
	<20080303162246.3f33ee24@cuia.boston.redhat.com>
	<Pine.LNX.4.61.0803031704290.7011@chaos.analogic.com>
Organization: Red Hat, Inc
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Mar 2008 17:10:53 -0500
"linux-os (Dick Johnson)" <linux-os@analogic.com> wrote:

> It is now being compiled one one of the target machines.
> If this works, I'll have to find the differences between
> the old and the newer and patch the linux-2.6.11 because
> it is a "certified" kernel, i.e., selected by the FAA and
> determined to be politically correct!

Selecting a kernel that everybody knows will not get
long term support does not strike me as the safest
choice for an FAA project.

-- 
All Rights Reversed
