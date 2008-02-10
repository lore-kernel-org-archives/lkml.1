Return-Path: <linux-kernel-owner+w=401wt.eu-S1756233AbYBJXYW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756233AbYBJXYW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 18:24:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752441AbYBJXYM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 18:24:12 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:50703 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751759AbYBJXYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 18:24:11 -0500
Message-ID: <47AF8790.1040706@torque.net>
Date: Sun, 10 Feb 2008 18:24:00 -0500
From: Douglas Gilbert <dougg@torque.net>
Reply-To: dougg@torque.net
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi_error: Fix language abuse.
References: <20080208153217.5fc42a50@core>	<47AD02C6.70402@torque.net> <20080209135020.6eca03ac@core>
In-Reply-To: <20080209135020.6eca03ac@core>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> On Fri, 08 Feb 2008 20:32:54 -0500
> Douglas Gilbert <dougg@torque.net> wrote:
> 
>> Alan Cox wrote:
>>> The word "illegal" has a precise dictionary meaning of "prohibited by
>>> law". 
>> Also "contrary to or forbidden by official rules, regulations, etc".
> 
> The OED I have here doesn't seem to think so, however if the words are
> the ones used in the T10 documentation then I'm happy to drop the patch.

The OED (Oxford English dictionary) seems to be at odds
with most other online dictionaries with respect to the
word illegal. I find the following 'illegal' entry
(at www.askoxford.com) daft:
  "USAGE Both illegal and unlawful can mean 'contrary to
   or forbidden by law', but unlawful has a broader meaning
   'not permitted by rules': thus handball in soccer is
   unlawful, but not illegal."

So if we followed the OED's advice then SCSI's "illegal
request" would become "unlawful request". I'm yet to
see the word "unlawful" in any technical standard ...

Doug Gilbert



