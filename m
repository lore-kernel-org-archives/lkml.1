Return-Path: <linux-kernel-owner+w=401wt.eu-S1760330AbYCFVvp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760330AbYCFVvp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 16:51:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933686AbYCFVuy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 16:50:54 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58712 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933685AbYCFVux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 16:50:53 -0500
Message-ID: <47D06717.9000104@zytor.com>
Date: Thu, 06 Mar 2008 13:50:15 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Pavel Machek <pavel@ucw.cz>, Pawel Plociennik <paplociennik@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.24] chroot= as a new kernel parameter
References: <200803060001.38432.paplociennik@gmail.com> <47CF79E4.3030107@zytor.com> <20080306102712.GE13391@elte.hu> <47D00B16.6040004@zytor.com> <20080306212028.GB1747@elf.ucw.cz> <20080306214218.GA886@elte.hu>
In-Reply-To: <20080306214218.GA886@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> 
> i really find it so disheartening at times that people fight trivial 
> usability additions tooth and nail in a _9 million lines of code_ kernel 
> with a ... "bloat" argument.
> 

Because they come in one at a time, in a completely disorganized fashion 
(which you yourself complain on further down.)

Yes, I'm bitter about it because my multiyear attempt at cleaning up and 
modularizing this area was rejected, and I had to find out about it 
secondhand.

To hell with it all.

	-hpa
