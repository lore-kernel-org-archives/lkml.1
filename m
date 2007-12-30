Return-Path: <linux-kernel-owner+w=401wt.eu-S1754896AbXL3D11@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896AbXL3D11 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 22:27:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752905AbXL3D1T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 22:27:19 -0500
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:39137 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088AbXL3D1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 22:27:19 -0500
Message-ID: <47770F80.1070800@keyaccess.nl>
Date: Sun, 30 Dec 2007 04:24:48 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: pharon@gmail.com
CC: "David P. Reed" <dpreed@reed.com>,
       Richard Harman <richard@richardharman.com>,
       Eduard-Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] Option to disable AMD C1E (allows dynticks to work)
References: <47765D11.2040903@reed.com>	 <1198967334.5049.3.camel@iamer-laptop>  <4776F6A0.9010801@keyaccess.nl> <1198979361.11150.2.camel@iamer-laptop>
In-Reply-To: <1198979361.11150.2.camel@iamer-laptop>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30-12-07 02:49, Islam Amer wrote:

> Glad I could be of help.
> 
> Sure please go ahead, I will keep testing this patch with upcoming git
> kernels, and report any problems.

Thanks. I'll see if Linus wants it for 2.6.24 still. Could be minimal enough.

> So what I understand now is that AMD C1E state saves battery like
> dynticks, so we don't need dynticks ?

That bit I haven't a clue about I'm afraid...

Rene.
