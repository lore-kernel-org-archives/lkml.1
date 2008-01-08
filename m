Return-Path: <linux-kernel-owner+w=401wt.eu-S1758137AbYAHJAs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758137AbYAHJAs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 04:00:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750727AbYAHJAk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 04:00:40 -0500
Received: from py-out-1112.google.com ([64.233.166.182]:46420 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753506AbYAHJAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 04:00:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Ez/NaMzzoCBYm3lqqPhTIPvSMpFMNRRTBh1hcA5Ghvgg50y2gKZoUOOLe+EYCiFFAXRXfMNj+jlbNAIgwgAA+iC+qTMEV/5E6YB2p/V21eWlSs0edcDcIFIKMSYXUPLtIkTCDJlBm/ctN1wLycflgHNqjEphAMilKi7WMstR22U=
Message-ID: <386072610801080100w30b7c6dar773e47de1472a030@mail.gmail.com>
Date: Tue, 8 Jan 2008 17:00:37 +0800
From: "Bryan Wu" <cooloney.lkml@gmail.com>
To: "Pekka Enberg" <penberg@cs.helsinki.fi>
Subject: Re: New linux arch
Cc: "Michal Simek" <simekm2@fel.cvut.cz>, linux-kernel@vger.kernel.org,
       monstr@monstr.eu
In-Reply-To: <84144f020801080049r487690ffv9f49c68160b205d2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47820D24.3060800@fel.cvut.cz>
	 <386072610801080028w7bb9735cs7c104af146c0ab3d@mail.gmail.com>
	 <84144f020801080049r487690ffv9f49c68160b205d2@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 8, 2008 4:49 PM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> Hi Bryan,
>
> On Jan 8, 2008 10:28 AM, Bryan Wu <cooloney.lkml@gmail.com> wrote:
> > 1. Push patches to LKML when merge window open (2 weeks after a stable
> > kernel version release, for example 2 weeks after 2.6.24 released)
>
> You shouldn't wait for the merge window to open to send patches for
> review for the first time; otherwise you'll just miss the opportunity
> to merge ;-).
>

Really? I was told before to send out big patch to LKML for the merge window.
If not, it's good news for Michal and MicroBlaze guys.

Thanks
-Bryan Wu
