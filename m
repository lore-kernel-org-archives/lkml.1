Return-Path: <linux-kernel-owner+w=401wt.eu-S1762491AbYEES4n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762491AbYEES4n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 14:56:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752476AbYEES4f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 14:56:35 -0400
Received: from hpsmtp-eml14.kpnxchange.com ([213.75.38.114]:55144 "EHLO
	hpsmtp-eml14.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751406AbYEES4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 14:56:34 -0400
From: Frans Pop <elendil@planet.nl>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Subject: Re: [git head] Should X86_PAT really default to yes?
Date: Mon, 5 May 2008 20:56:31 +0200
User-Agent: KMail/1.9.9
Cc: "Yinghai Lu" <yhlu.kernel@gmail.com>,
       "Barnes, Jesse" <jesse.barnes@intel.com>, linux-kernel@vger.kernel.org,
       "Ingo Molnar" <mingo@elte.hu>,
       "Packard, Keith" <keith.packard@intel.com>
References: <200805022122.03576.elendil@planet.nl> <200805051855.05496.elendil@planet.nl> <924EFEDD5F540B4284297C4DC59F3DEEFB9204@orsmsx423.amr.corp.intel.com>
In-Reply-To: <924EFEDD5F540B4284297C4DC59F3DEEFB9204@orsmsx423.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805052056.31808.elendil@planet.nl>
X-OriginalArrivalTime: 05 May 2008 18:56:32.0539 (UTC) FILETIME=[BC052EB0:01C8AEE1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 May 2008, Pallipadi, Venkatesh wrote:
> >On Sunday 04 May 2008, Yinghai Lu wrote:
> >> can you boot with pat=off and send out /proc/mtrr?
> >
> >Hmmm. Is 'pat=off' supposed to do anything?
>
> The option for this is actually "nopat".

Yes, that does work. Thanks.

Contents of /proc/mtrr remain unchanged.
