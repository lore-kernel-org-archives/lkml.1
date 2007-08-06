Return-Path: <linux-kernel-owner+w=401wt.eu-S933821AbXHFXsq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933821AbXHFXsq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 19:48:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932250AbXHFXsi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 19:48:38 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:39027 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932524AbXHFXsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 19:48:37 -0400
Message-ID: <46B7B2A3.3020907@gmail.com>
Date: Tue, 07 Aug 2007 01:45:39 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Mitchell Erblich <erblichs@earthlink.net>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       "T. J. Brumfield" <enderandrew@gmail.com>
Subject: Re: about modularization
References: <000b01c7d873$76ce03c0$6501a8c0@earthlink.net> <46B7B045.5070607@gmail.com>
In-Reply-To: <46B7B045.5070607@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2007 01:35 AM, Rene Herman wrote:

> On 08/06/2007 11:48 PM, Mitchell Erblich wrote:
> 
>> Of the uni-processor systems currently that can run Linux, I would not 
>> doubt if 99.9999% percent are uni-cores.
> 
> s/can// and I would. s/uni-processor// additionally and I'd assure you 
> it's untrue. s/uni-cores/non-smt uni-cores/ and I'd do the same.

(no, that's obviously wrong given embedded volumes, but as stated below, 
embedded is fine running non-generic, !CONFIG_SMP kernels).

Rene.
