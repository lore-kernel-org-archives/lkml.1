Return-Path: <linux-kernel-owner+w=401wt.eu-S965482AbXJPTX0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965482AbXJPTX0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 15:23:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933970AbXJPTXQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 15:23:16 -0400
Received: from smtp-01.mandic.com.br ([200.225.81.132]:33996 "EHLO
	smtp-01.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933824AbXJPTXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 15:23:16 -0400
Message-ID: <47150F98.3040601@mandic.com.br>
Date: Tue, 16 Oct 2007 17:23:04 -0200
From: "Renato S. Yamane" <renatoyamane@mandic.com.br>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Jeremy Katz <katzj@redhat.com>, hmh@hmh.eng.br,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       davej@redhat.com
Subject: Re: [PATCH] Map volume and brightness events on thinkpads
References: <1192481110-9299-1-git-send-email-katzj@redhat.com> <20071016185351.GC25181@srcf.ucam.org>
In-Reply-To: <20071016185351.GC25181@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Garrett wrote:
> On Mon, Oct 15, 2007 at 04:45:10PM -0400, Jeremy Katz wrote:
>> There are standard keycodes for brightness and volume; map the events to
>> emit them so that things work properly
> 
> We've been doing this in Ubuntu for a couple of years now, with no 
> obvious difficulty.

One detail: any Kernel don't recognize multimedia keys or couple keys 
(Fn+Fx) on my Toshiba M45-S355.
If I use xev, I can't get any output.

Regards,
Renato
