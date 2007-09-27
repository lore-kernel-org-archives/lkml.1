Return-Path: <linux-kernel-owner+w=401wt.eu-S1757773AbXI0SQA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757773AbXI0SQA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 14:16:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755279AbXI0SPw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 14:15:52 -0400
Received: from main.gmane.org ([80.91.229.2]:43731 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752819AbXI0SPv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 14:15:51 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: New 'Changes-licensed-under' tag introduced for Linux-wireless
Date: Thu, 27 Sep 2007 11:09:50 -0700
Organization: Linux Foundation
Message-ID: <20070927110950.0561eca1@freepuppy.rosehill>
References: <43e72e890709271100n39f16c18x723dc7a85d418666@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: 069-064-229-129.pdx.net
In-Reply-To: <43e72e890709271100n39f16c18x723dc7a85d418666@mail.gmail.com>
X-Newsreader: Claws Mail 3.0.0 (GTK+ 2.10.14; x86_64-redhat-linux-gnu)
Cc: linux-wireless@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Sep 2007 14:00:09 -0400
"Luis R. Rodriguez" <mcgrof@gmail.com> wrote:

> Our guidelines for patches [1] for Linux-wireless has been updated.
> One section asks Linux-wireless developers to subscribe to the patch
> guideline wiki page (section 2) and another which introduces the new
> 'Changes-licensed-under' (section 10).
> 
> Here I'll cover the new 'Changes-licensed-under' tag but please refer
> to the link and subscribe to the page for the complete details and for
> further changes.
> 

No, please don't down this legal rat hole. It would cause bullshit like
people submitting dual licensed patches to the scheduler or GPL only
patches to the ath5k or ACPI code.

Instead, add a section to Documentation/SubmittingPatches that clearly
states that all changes to a file are licensed under the same license
as the original file. I don't feel legally qualified to write the correct
wording.


-- 
Stephen Hemminger <shemminger@linux-foundation.org>

