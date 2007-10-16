Return-Path: <linux-kernel-owner+w=401wt.eu-S933164AbXJPQmQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933164AbXJPQmQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 12:42:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755897AbXJPQmB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 12:42:01 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:60697 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754065AbXJPQmA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 12:42:00 -0400
Message-ID: <4714E9D5.7040303@garzik.org>
Date: Tue, 16 Oct 2007 12:41:57 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Konstantin Kalin <konstantin.kalin@gmail.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: NVIDIA Ethernet & invalid MAC
References: <4714C66D.4010607@gmail.com>	<20071016154313.53d19c43@the-village.bc.nu>	<4714D5B8.8020301@redhat.com> <20071016164354.6f4e530a@the-village.bc.nu> <4714E02D.7040804@garzik.org> <4714E842.8020105@gmail.com>
In-Reply-To: <4714E842.8020105@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Konstantin Kalin wrote:
> I'm sorry, but I think that Alan proposed in the first email is more 
> than a hack. It would solve the issue for different versions and the 
> check is trivial. Or am I mistaken?

It assumes a constant MAC address vendor ID.

	Jeff


