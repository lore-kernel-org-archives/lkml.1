Return-Path: <linux-kernel-owner+w=401wt.eu-S1765987AbXLNLPf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765987AbXLNLPf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 06:15:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759396AbXLNLP0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 06:15:26 -0500
Received: from wa-out-1112.google.com ([209.85.146.183]:42754 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753750AbXLNLPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 06:15:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=a9U/AD+GeXBeqzz5eKo7awsdxtTQ3Pz2cDPf1JMlFzYZ+I87wD/Ujj9fnvtBt0Kr5/s5Iy6r0uv7yCYNx9PsYk/EwDnKC81Mf+oURAL7C+c3xLhoHQJcceqUIwqBHyB0xZX3p0UIz8cgw0TMQjhY+1DzyeOJY7y31maf2Rhlimk=
Message-ID: <9a8cbed90712140315v27148168k304853ee8d6572ec@mail.gmail.com>
Date: Fri, 14 Dec 2007 06:15:25 -0500
From: "Arun Thomas" <arun.thomas@gmail.com>
To: "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: PROBLEM: E6850 has an 8+ minute delay during boot
Cc: "Jiri Slaby" <jirislaby@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <alpine.LFD.0.99999.0712141140310.10584@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9a8cbed90712140110l156a34e3x38533b7710544cf8@mail.gmail.com>
	 <20071214015315.09829a99.akpm@linux-foundation.org>
	 <9a8cbed90712140201r6cb287d9w99cc1210c68e8e60@mail.gmail.com>
	 <4762586F.8090603@gmail.com>
	 <alpine.LFD.0.99999.0712141140310.10584@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 14, 2007 5:43 AM, Thomas Gleixner <tglx@linutronix.de> wrote:

>
> Arun, do you have an USB keyboard plugged in ? If not, can you connect
> one and check, whether it changes things or not ?

I had a USB keyboard and mouse connected when I encountered the
problem. Do you want me to try with a PS/2 keyboard/mouse?

Thanks,
Arun
