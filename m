Return-Path: <linux-kernel-owner+w=401wt.eu-S932306AbZJSV3y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932306AbZJSV3y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 17:29:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932287AbZJSV3x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 17:29:53 -0400
Received: from aglcosbs02.cos.agilent.com ([192.25.218.39]:41064 "EHLO
	aglcosbs02.cos.agilent.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932265AbZJSV3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 17:29:53 -0400
Message-ID: <4ADCDA2F.1090209@agilent.com>
Date: Mon, 19 Oct 2009 14:29:19 -0700
From: Earl Chew <earl_chew@agilent.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: dwalker@fifo99.com
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/1]: fs: pipe.c null pointer dereference + sign off
References: <4AD8852E.2090302@agilent.com>  <4ADCAC33.4070908@agilent.com> <1255981395.23353.46.camel@desktop>
In-Reply-To: <1255981395.23353.46.camel@desktop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Oct 2009 21:29:23.0439 (UTC) FILETIME=[3A1077F0:01CA5103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Walker wrote:
> You patch looks like it might be line wrapped .. Sometimes mailers will
> do that if you don't tell them the content is already formatted.

Arghhh ... struck by Thunderbirditis.

Apparently mailnews.send_plaintext_flowed=false is the key to
preserving tabs, and the Toggle Word Wrap extension is useful
for to avoid inserting additional newlines:

https://addons.mozilla.org/en-US/thunderbird/addon/2351

As you can see, I'm new to this game. Your patience is appreciated.

I'll repost.

> Also I see your using a MontaVista kernel, which is older than current
> mainline .. I would assume you tested this on a recent kernel also?

I don't have immediate access to a more recent kernel.

The changes are fairly straightforward and I have added extensive
documentation on how to reproduce and verify the defect.

Is anyone interested in helping out here by verifying on a
more recent kernel?

Earl


