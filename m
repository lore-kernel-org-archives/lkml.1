Return-Path: <linux-kernel-owner+w=401wt.eu-S1752622AbYKMAd2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752622AbYKMAd2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 19:33:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751261AbYKMAdT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 19:33:19 -0500
Received: from styx.suse.cz ([82.119.242.94]:53488 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751081AbYKMAdS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 19:33:18 -0500
Date: Thu, 13 Nov 2008 01:33:17 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Jiri Slaby <jirislaby@gmail.com>, Alexey Klimov <klimov.linux@gmail.com>
cc: Tobias Lorenz <tobias.lorenz@gmx.net>,
       Mauro Carvalho Chehab <mchehab@redhat.com>, linux-input@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: next: 6a13378a5 (Don't allow KWorld radio...) is broken
In-Reply-To: <491B3E90.5020307@gmail.com>
Message-ID: <alpine.LNX.1.10.0811130131190.32143@jikos.suse.cz>
References: <491B3E90.5020307@gmail.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Nov 2008, Jiri Slaby wrote:

> The commit below is apparently wrong. Maybe you CCed HID maintainer, 
> however linux-input didn't get the message, or at least I can't find it 
> anywhere.

Jiri, thanks for noticing. 
No, I don't seem to have been CCed on that patch, and it is apparently 
wrong indeed. 

Alexey, did you actually test it?
I'd prefer taking this through my tree, if it doesn't impose any problem 
on your side. Could you please fix it up and resend?

Thanks,

-- 
Jiri Kosina
