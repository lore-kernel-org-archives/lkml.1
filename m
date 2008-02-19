Return-Path: <linux-kernel-owner+w=401wt.eu-S1755893AbYBSWA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893AbYBSWA0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 17:00:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762145AbYBSWAA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 17:00:00 -0500
Received: from nn7.de ([85.214.94.156]:60614 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762126AbYBSV76 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 16:59:58 -0500
Subject: Re: 2.6.25-rc2 regression - hang on suspend
From: Soeren Sonnenburg <kernel@nn7.de>
To: "Rafael J\. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <200802192206.13350.rjw@sisk.pl>
References: <1203422386.10992.2.camel@localhost>
	 <200802192206.13350.rjw@sisk.pl>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 19 Feb 2008 22:59:54 +0100
Message-Id: <1203458394.28475.7.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-02-19 at 22:06 +0100, Rafael J. Wysocki wrote:
> On Tuesday, 19 of February 2008, Soeren Sonnenburg wrote:
> > Hi,
> 
> Hi,
> 
> > since 2.6.25-rc1 (first version I tried) and still in rc2 (and git), I
> > see a hang on s2ram already when trying to suspend.
> 
> Does it work with 2.6.24?

yes.

Soeren
