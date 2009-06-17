Return-Path: <linux-kernel-owner+w=401wt.eu-S1761345AbZFQUke@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761345AbZFQUke (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 16:40:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757056AbZFQUkT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 16:40:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35657 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752652AbZFQUkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 16:40:18 -0400
Message-ID: <4A3954AD.8000305@zytor.com>
Date: Wed, 17 Jun 2009 13:40:13 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: "Dr. David Alan Gilbert" <linux@treblig.org>
CC: Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-input@vger.kernel.org
Subject: Re: 2.6.{28,30} Keyboard not working on oldish machine
References: <20090613230842.GA18347@gallifrey> <4A349B67.1070603@zytor.com> <20090614122734.GA1499@gallifrey> <alpine.LRH.2.00.0906161126330.31685@twin.jikos.cz> <20090617193442.GA31944@gallifrey>
In-Reply-To: <20090617193442.GA31944@gallifrey>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dr. David Alan Gilbert wrote:
> 
> Please find below the new dmesg created by appending i8042.debug; this was
> taken from a slightly newer build of the same source kernel that I reported; this
> build just had a few more things configured out (parallel port) but exhibits
> the same symptom.
> 
> No more debug is generated as I press any keys.
> 

What happens with the mouse?

	-hpa
