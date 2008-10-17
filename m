Return-Path: <linux-kernel-owner+w=401wt.eu-S1756210AbYJQAPs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756210AbYJQAPs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 20:15:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752813AbYJQAPk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 20:15:40 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36005 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752606AbYJQAPj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 20:15:39 -0400
Subject: Re: [PATCH] sony-laptop: Ignore missing _DIS method on pic device
From: Adam Jackson <ajax@redhat.com>
To: Mattia Dongili <malattia@linux.it>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       Matthew Garrett <mjg59@srcf.ucam.org>
In-Reply-To: <20081016224903.GD21963@inferi.kami.home>
References: <1224192550-366-1-git-send-email-ajax@redhat.com>
	 <20081016224903.GD21963@inferi.kami.home>
Content-Type: text/plain
Date: Thu, 16 Oct 2008 21:03:20 -0400
Message-Id: <1224205400.29257.67.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-10-17 at 07:49 +0900, Mattia Dongili wrote:
> On Thu, Oct 16, 2008 at 05:29:10PM -0400, Adam Jackson wrote:
> > From: Matthew Garrett <mjg59@srcf.ucam.org>
> > 
> > At least the Vaio VGN-Z540N doesn't have this method, so let's not fail
> > to suspend just because it doesn't exist.
> 
> Do you happen to have a DSDT dump for this model? I'd be glad to see it.

'iasl -d' output:

http://people.freedesktop.org/~ajax/synephrine-dsdt.dsl

- ajax

